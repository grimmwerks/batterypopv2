$(document).ready(function() {    

    var pollSlider = $('.poll-slider').bxSlider({
        
        onSlideAfter: function(item){
           
            var id = item[0].getAttribute('data-id');
            var q = item[0].getAttribute('data-question');
            var j = "#poll_question_"+q;
            $(j).val(id);
        
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
        infiniteLoop: false,
        hideControlOnEnd: true,
        slideMargin: 0
    })




});