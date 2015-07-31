$(function() {


    var source = new EventSource('/park_stream');

    source.addEventListener('results', function(e){
      console.log('Received a message:', e.data);
      if ( $.parseJSON(e.data).lstatus ) {
      var b = $.parseJSON(e.data).lstatus;
      var zcu = $.parseJSON(e.data).zcid;
      var floor = $.parseJSON(e.data).fid;
      var building = $.parseJSON(e.data).bid;
      svg_change(b,zcu,floor,building);

      } else if ($.parseJSON(e.data).total){

      var vacant  = $.parseJSON(e.data).vacant;
      var occupied = $.parseJSON(e.data).occupied;
      var reserved = $.parseJSON(e.data).reserved;
      var total   = $.parseJSON(e.data).total;
      var floor = $.parseJSON(e.data).fid;
      var building = $.parseJSON(e.data).bid;
                $('#vacant'+floor+building).text(vacant);
                $('#occupied'+floor+building).text(occupied);
                $('#reserved'+floor+building).text(reserved);
                $('#total'+floor+building).text(total);

      } else if ($.parseJSON(e.data).total_b){

      var vacant  = $.parseJSON(e.data).vacant_b;
      var occupied = $.parseJSON(e.data).occupied_b;
      var reserved = $.parseJSON(e.data).reserved_b;
      var total   = $.parseJSON(e.data).total_b;
      var building = $.parseJSON(e.data).bid;
                $('#vacant'+building).text(vacant);
                $('#occupied'+building).text(occupied);
                $('#reserved'+building).text(reserved);
                $('#total'+building).text(total);
      }

    });
       

	function svg_change(b,zcu,fl,bu) {
          var object = document.getElementById("" + bu + fl);
          var svgdoc;
            svgdoc = object.contentDocument;

               var a = b.split("");
               var c;
	       //var rect = [];
	       var i = 0, j = i+1;
               var len = b.length;
	       //alert (a);
               for (; i < len; i++, j++) {
                  rect = svgdoc.getElementById("slot-"+bu+"-"+fl+"-"+zcu+"-"+j);
                if (a[i] == "o"){ 
                  rect.style.setProperty("fill", "red");
		} else if(a[i] == "v")  {
 
                  function callback() {
                    this.style.setProperty("fill", "orange");
                    $.ajax({
                      url: "/floor?slot="+this.id+"&status="+"r",
                      type: "post",
                      // data: values,
                      success: function(){
                      },
                      error: function(){
                        alert('Retry once again');
                      }
                    });
                    this.removeEventListener("mouseover", callback1, false); 
                    this.removeEventListener("mouseout", callback2, false); 
                  }

                  function callback1() {
                    this.style.setProperty("opacity", "1");
                  }

                  function callback2() {
                    this.style.setProperty("opacity", "0.5");
                  }

                  rect.style.setProperty("fill", "green");
               
                  $(rect).off().one('click', callback);

                  rect.addEventListener("mouseover", callback1, false); 
                  rect.addEventListener("mouseout", callback2, false); 

		} else if(a[i] == "r")  {

                  function callback() {
                    this.style.setProperty("fill", "green");
                    $.ajax({
                      url: "/floor?slot="+this.id+"&status="+"v",
                      type: "post",
                      // data: values,
                      success: function(){
                      },
                      error: function(){
                        alert('Retry once again');
                      }
                    });
                    this.removeEventListener("mouseover", callback1, false); 
                    this.removeEventListener("mouseout", callback2, false); 
                  }

                  function callback1() {
                    this.style.setProperty("opacity", "1");
                  }

                  function callback2() {
                    this.style.setProperty("opacity", "0.5");
                  }

                  rect.style.setProperty("fill", "orange");

                  $(rect).off().one('click', callback);

                  rect.addEventListener("mouseover", callback1, false); 
                  rect.addEventListener("mouseout", callback2, false); 
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
