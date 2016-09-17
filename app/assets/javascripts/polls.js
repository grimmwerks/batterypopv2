$(document).ready(function() {    

    var pollSlider = $('.poll-slider').bxSlider({
        
        onSlideAfter: function(item){
           
            var id = item[0].getAttribute('data-id');
            var q = item[0].getAttribute('data-question');
            var j = "#poll_question_"+q;
            $(j).val(id);
            $("#poll_slider_overlay_"+q).hide(150);
            $.ajax({
                type:'POST',
                url: '/poll_refresh_layer',
                data:{'answer_id':id,'question_id':q},
                success: function(data){
                    //alert(data);
                }
            });
        },
        
        auto: false,
        responsive: true,
        touchEnabled: true, 
        pager: false,
        minSlides: 1,
        maxSlides: 1,
        slideWidth: 240,
        infiniteLoop: true,
        hideControlOnEnd: false,
        slideMargin: 0
    });



    $('#poll_scene_download').click(function(){
        $.ajax({
            type:'POST',
            url: '/download',
            data: {id: $(this).attr("data-id")}
        });
    });



});

function check_poll_submit(){
    var answers = $(".poll_answer");
    var flag = true;
    answers.each(function (index){
        if($(this).val()==""){
            flag = false;
        }
    });
    if(flag==false){
        $('#pollModal').modal('show'); 
    }
    return flag;
}