// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-transition.js
//= require bootstrap-alert.js
//= require bootstrap-modal.js
//= require bootstrap-dropdown.js
//= require bootstrap-tab.js
//= require bootstrap-tooltip.js
//= require bootstrap-popover.js
//= require bootstrap-button.js
//= require bootstrap-collapse.js
//= require bootstrap-typeahead.js
//= require bootstrap
//= require jquery.autosize
//= jquery-ui.triggeredAutocomplete
//= jquery.ui.touch-punch.min
//= require bootstrap-datepicker

function hide_removed_task() {
    $(".alone_comment i.icon-trash").live("click", function () {
        $(this).parents(".alone_comment").slideUp("slow")
    })
}


$(document).on("focus", "[data-behaviour~='datepicker']", function (e) {
    $(this).datepicker({"format":"yyyy-mm-dd", "weekStart":1, "autoclose":true});
});


function in_duscussion_too_small_length() {

    $("#task_comment").parents("form:first").on("submit", function (e) {
        text = $(this).find("textarea:first").val();
        if (text.length < 2) {
            alert("That's all?");
            return false;
        }
    })


}

$(document).ready(function () {
    $('textarea').autosize({append:"\n"});

    if ($("#task_comment").length > 0) {
        in_duscussion_too_small_length();
    }

    hide_removed_task();


});



