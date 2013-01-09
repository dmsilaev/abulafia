class JabberBot
  # To change this template use File | Settings | File Templates.
  attr_accessor :user, :message, :bot

  include Rails.application.routes.url_helpers

  def initialize(*args)
    @options = args.extract_options!
    self.user = @options.delete(:user).presence || nil
    self.message = @options.delete(:message).presence || nil
    self.bot = $hipchat_bot
    self
  end

  def connect
    self.bot.connect
    self.bot.auth(KEYS['bot']['hipchat']['password'])
  end

  def change
    client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
    Rails.logger.debug "*** Change bot ***"
    KEYS['bot']['hipchat']['jid'].each do |jid|
      unless self.bot.jid.to_s == "#{jid}/none"
        self.bot.close
        $hipchat_bot = Jabber::Client::new(Jabber::JID::new(jid))
        self.bot = $hipchat_bot
        begin
          Rails.logger.debug self.connect
        rescue
          Rails.logger.error "IOError bot error in CHANGE"
          #@flag_of_
          next
        end
        client['abulafia'].send('Bot is change', "his jid #{$hipchat_bot.jid}", :color => 'green', :notify => true)
        break
      end
    end
  end





  def send_message
    Rails.logger.debug "**** Send message ****"
    if self.user.present?
      client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")

      self.user.each do |u|
        begin
          client['abulafia'].send('bot', "List of users to notify ** #{u.login} **,<br/> '#{self.message}'", :color => 'yellow')
        rescue Exception
          Rails.logger.error "Error sending message. #{Exception.to_json}"
        end

        if u.hc_user_id.nil?
          raise "send mail!"
          # email send
        else
          address ="#{KEYS['bot']['hipchat']['company']}_#{u.hc_user_id}@#{KEYS['bot']['hipchat']['host']}"
          message = Jabber::Message::new(address, self.message)
          message.set_type(:chat)

          KEYS['bot']['hipchat']['jid'].each_index do |jid|
            begin
              @mail_flag = false
              unless self.bot.is_connected?
                self.connect
              end
              sending_robot = self.bot.send(message)
              client['abulafia'].send('bot', "Send notification OK! <br />  To: #{u.login}, <br/>  Message: '#{self.message}'", :color => 'green')
              client['abulafia'].send('bot', sending_robot.to_json, :color => 'green')
            rescue
              @mail_flag = true
              Rails.logger.error "!!!!!!! IOError bot error"
              client['abulafia'].send('bot', "BOT #{jid} is down! IOError", :color => 'red', :notify => true)
              self.change
              next
            end
            break
          end
          if @mail_flag
            # email send
            raise "send mail!"
          end
        end
        #begin
        #  sending_robot = robot.send(message)
        #
        #  client['abulafia'].send('bot', "Send notification OK! <br />  To: #{u.login}, <br/>  Message: '#{self.message}'", :color => 'green')
        #  client['abulafia'].send('bot', sending_robot.to_json, :color => 'green')
        #
        #rescue IOError
        #  Rails.logger.error "!!!!!!! IOError bot error"
        #  client['abulafia'].send('bot', "BOT is down! IOError", :color => 'red', :notify => true)
        #
        #  #send notification via email
        #
        #  #BotMailer.send_email(u, self.message).deliver
        #else
        #
        #  Rails.logger.error "Bot error, not IOError bot error exception"
        #  Rails.logger.info "Mail but bot"
        #
        #  #BotMailer.send_email(u, self.message).deliver
        #
        #
        #end

      end
    end
  end


  def get_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def get_task_url(task)
    "http://#{get_host}#{task_url(task, :only_path => true)}"
  end


  def message_for_task(task)

    self.message = "Task assigned to you: \"#{task.title}\" in project " +
        " \"#{task.project.name}\", "+
        "by #{task.owner.fio}, "+
        "url: #{get_task_url(task)}"
  end

  def message_for_comment(comment)
    self.message = " New comment \"#{comment.comment}\""+
        ", Discussion: \"#{comment.commentable.title}\""+
        ", Project: \"#{comment.commentable.discussable.project.name}\"" +
        ", Url: #{get_task_url(comment.commentable.discussable)}"
  end

end