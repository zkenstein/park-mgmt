$(function() 
     {
         
         $("#svgload").svg({
           onLoad: function()
                        {
                       var svg = $("#svgload").svg('get');
          svg.load('assets/drawing_plain.svg', {addTo: true,  changeSize: false});        
                       },
        settings: {}
          });  

         
    var source = new EventSource('/user_stream');

    source.addEventListener('results', function(e){
      console.log('Received a message:', e.data);
      var b = $.parseJSON(e.data).pdata;
      svg_change(b);
    });

	function svg_change(b) {
               var a = b.split("");
	       var rect;
	       var i = 0, j = i+1;
               var len = b.length;
	       //alert (a);
               for (; i <= len; i++, j++) {
                rect = $('#slot'+ j);
		//alert (a[i]);
		if (a[i] == 1) {
                rect.css('fill','red');
		}
		else {
                rect.css('fill','green');
		}
		}
         }

    source.addEventListener('finished', function(e){
      console.log('Close:', e.data);
      source.close();
    });


          $('#btnTest').click(function(e)
           {
           });    
     });
