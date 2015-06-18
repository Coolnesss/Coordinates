/**
* Define a namespace for the application.
*/
window.app = {};
var app = window.app;



/**
* @constructor
* @extends {ol.interaction.Pointer}
*/
app.Drag = function() {

  ol.interaction.Pointer.call(this, {
    handleDownEvent: app.Drag.prototype.handleDownEvent,
    handleDragEvent: app.Drag.prototype.handleDragEvent,
    handleMoveEvent: app.Drag.prototype.handleMoveEvent,
    handleUpEvent: app.Drag.prototype.handleUpEvent
  });

  /**
  * @type {ol.Pixel}
  * @private
  */
  this.coordinate_ = null;

  /**
  * @type {string|undefined}
  * @private
  */
  this.cursor_ = 'pointer';

  /**
  * @type {ol.Feature}
  * @private
  */
  this.feature_ = null;

  /**
  * @type {string|undefined}
  * @private
  */
  this.previousCursor_ = undefined;

};
ol.inherits(app.Drag, ol.interaction.Pointer);


/**
* @param {ol.MapBrowserEvent} evt Map browser event.
* @return {boolean} `true` to start the drag sequence.
*/
app.Drag.prototype.handleDownEvent = function(evt) {
  var map = evt.map;

  var feature = map.forEachFeatureAtPixel(evt.pixel,
    function(feature, layer) {
      return feature;
    });

    if (feature) {
      this.coordinate_ = evt.coordinate;
      this.feature_ = feature;
    }

    return !!feature;
  };


  /**
  * @param {ol.MapBrowserEvent} evt Map browser event.
  */
  app.Drag.prototype.handleDragEvent = function(evt) {
    var map = evt.map;

    var feature = map.forEachFeatureAtPixel(evt.pixel,
      function(feature, layer) {
        return feature;
      });

      var deltaX = evt.coordinate[0] - this.coordinate_[0];
      var deltaY = evt.coordinate[1] - this.coordinate_[1];

      var geometry = /** @type {ol.geom.SimpleGeometry} */
      (this.feature_.getGeometry());
      geometry.translate(deltaX, deltaY);

      this.coordinate_[0] = evt.coordinate[0];
      this.coordinate_[1] = evt.coordinate[1];

      $('#lon').val(evt.coordinate[0]);
      $('#lat').val(evt.coordinate[1]);

      //$('#coord').text(evt.coordinate[0]+'    '+evt.coordinate[1]);
    };


    /**
    * @param {ol.MapBrowserEvent} evt Event.
    */
    app.Drag.prototype.handleMoveEvent = function(evt) {
      if (this.cursor_) {
        var map = evt.map;
        var feature = map.forEachFeatureAtPixel(evt.pixel,
          function(feature, layer) {
            return feature;
          });
          var element = evt.map.getTargetElement();
          if (feature) {
            if (element.style.cursor != this.cursor_) {
              this.previousCursor_ = element.style.cursor;
              element.style.cursor = this.cursor_;
            }
          } else if (this.previousCursor_ !== undefined) {
            element.style.cursor = this.previousCursor_;
            this.previousCursor_ = undefined;
          }
        }
      };


      /**
      * @param {ol.MapBrowserEvent} evt Map browser event.
      * @return {boolean} `false` to stop the drag sequence.
      */
      app.Drag.prototype.handleUpEvent = function(evt) {
        this.coordinate_ = null;
        this.feature_ = null;
        return false;
      };




      ////////////////////////
      var coordinates = [
      [24.94409, 60.17065, 'Piste1', "Mauris sed libero. Suspendisse facilisis nulla in lacinia laoreet, lorem velit accumsan velit vel mattis libero nisl et sem. Proin interdum maecenas massa turpis sagittis in, interdum non lobortis vitae massa. Quisque purus lectus, posuere eget imperdiet nec sodales id arcu. Vestibulum elit pede dictum eu, viverra non tincidunt eu ligula."],
      [24.93804, 60.16968, 'Piste2', "Mauris sed libero. Suspendisse facilisis nulla in lacinia laoreet, lorem velit accumsan velit vel mattis libero nisl et sem. Proin interdum maecenas massa turpis sagittis in, interdum non lobortis vitae massa. Quisque purus lectus, posuere eget imperdiet nec sodales id arcu. Vestibulum elit pede dictum eu, viverra non tincidunt eu ligula."]
      ];

      var vectorSource = new ol.source.Vector({
        //create empty vector
      });


      function addPoints() {
        var y = 0;

        //create a bunch of icons and add to source vector
        for (var i = 0; i < coordinates.length; i++) {
          var iconFeature = new ol.Feature({
            geometry: new ol.geom.Point(ol.proj.transform(coordinates[i], 'EPSG:4326', 'EPSG:3857')),
            name: coordinates[i][2],
            description: coordinates[i][3],
            id: i
          });
          //alert(coordinates[z][2]);
          y++;
          vectorSource.addFeature(iconFeature);

        }
      }

      addPoints();

      //create the style
      //        var iconStyle = new ol.style.Style({
      //            image: new ol.style.Icon( /** @type {olx.style.IconOptions} */ ({
      //                anchor: [0.5, 46],
      //                anchorXUnits: 'fraction',
      //                anchorYUnits: 'pixels',
      //                opacity: 0.75,
      //                src: 'http://ol3js.org/en/master/examples/data/icon.png'
      //            }))
      //        });
      var fill = new ol.style.Fill({
        color: 'rgba(255,0,0,0.7)',
        opacity: 0.4
      });

      var iconStyle = new ol.style.Style({

        image: new ol.style.Circle({
          fill: fill,
          radius: 12
        })

      });

      var fill2 = new ol.style.Fill({
        color: 'rgba(255,0,0,0)',
        opacity: 0
      });

      var iconStyle2 = new ol.style.Style({

        image: new ol.style.Circle({
          fill: fill2,
          radius: 12
        })

      });


      //add the feature vector to the layer vector, and apply a style to whole layer
      var vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        style: iconStyle
      });

      //Map layer
      var rasterLayer = new ol.layer.Tile({
        source: new ol.source.MapQuest({
          layer: "osm"
        })
      });

      var view = new ol.View({
        center: ol.proj.transform([24.9312, 60.1793], 'EPSG:4326', 'EPSG:3857'),
        zoom: 13
      });

      //Create map
      var map = new ol.Map({
        //interactions: ol.interaction.defaults().extend([new app.Drag()]),
        layers: [rasterLayer, vectorLayer],
        target: document.getElementById('map'),
        view: view
      });

      var element = document.getElementById('popup');

      var popup = new ol.Overlay({
        element: element,
        positioning: 'bottom-center',
        stopEvent: false
      });
      map.addOverlay(popup);
      var tmp;
      // display popup on click
      map.on('click', function(evt) {
        var feature = map.forEachFeatureAtPixel(evt.pixel,
          function(feature, layer) {
            return feature;
          });
          if (feature) {
            /*var geometry = feature.getGeometry();
            var coord = geometry.getCoordinates();
            popup.setPosition(coord);
            $(element).popover({
            'placement': 'top',
            'html': true,
            'content': feature.get('name') + '<br>' + feature.get('description')
          });
          $(element).popover('show');*/
          feature.setStyle(iconStyle);
          feature.setId(800);

          tmp = feature.getId();
          //alert(tmp);
          //vectorSource.removeFeature(tmp);
          $('.descName').text(feature.get('name'));
          $('.descP').text(feature.get('description'));
          $('#descFooter').css("visibility","visible");
          $('#imgWrap').fadeTo(200,1);
        } else {

          tmp = false;
          $('.descName').text('');
          //$('#vote').text('');
          $('#descFooter').css("visibility","hidden");
          $('.descP').html('<br>Klikkaa kohdetta nÃ¤hdÃ¤ksesi lisÃ¤tietoja.<br><br>TÃ¤hÃ¤n epic stats?');
          $('#imgWrap').fadeTo(200,0);
        }
      });

      // change mouse cursor when over marker
      map.on('pointermove', function(e) {

        if (e.dragging) {
          $(element).popover('destroy');
          return;
        }
        var pixel = map.getEventPixel(e.originalEvent);
        var hit = map.hasFeatureAtPixel(pixel);
        map.getTarget().style.cursor = hit ? 'pointer' : '';
      });

      var interaction = new app.Drag();

      $("#add").click(function() {

        //tmp = vectorLayer.getSource();
        //alert(tmp);

        //var j = vectorLayer.getSource().getFeatureById(420);
        //console.log(j);
        //alert(JSON.stringify(tmp.getFeatures(), null, 4));
        if (tmp == 800) {
          //alert(tmp);
          vectorSource.getFeatureById(tmp).setStyle(iconStyle2);
          vectorSource.removeFeature(vectorSource.getFeatureById(tmp));
        }

        vectorSource.clear();
        var pointFeature = new ol.Feature(new ol.geom.Point(map.getView().getCenter()));
        vectorSource.addFeature(pointFeature);
        map.addInteraction(interaction);





      });
      var select = new ol.interaction.Select();
      map.addInteraction(select);

      $("#close").click(function() {

        vectorSource.clear();
        addPoints();
        map.removeInteraction(interaction);
        delete tmp;
      });

      function resize() {
        var div = $('#map');
        div.height($(window).height());
        // div.height(
        //   Math.max(div.height() + ($(window).height() - $('body').height()), 300)
        //);
        map.updateSize();
      }
      resize();

      var espoo = ol.proj.transform([24.675114, 60.2080134], 'EPSG:4326', 'EPSG:3857')
      var vantaa = ol.proj.transform([25.0383766, 60.2933872], 'EPSG:4326', 'EPSG:3857')
      var helsinki = ol.proj.transform([24.9312, 60.1793], 'EPSG:4326', 'EPSG:3857')


      var panToEspoo = document.getElementById('espoo');
      panToEspoo.addEventListener('click', function() {
        var pan = ol.animation.pan({
          duration: 1200,
          source: /** @type {ol.Coordinate} */ (view.getCenter())
        });
        map.beforeRender(pan);
        view.setCenter(espoo);

      }, false);

      var panToVantaa = document.getElementById('vantaa');
      panToVantaa.addEventListener('click', function() {
        var pan = ol.animation.pan({
          duration: 1200,
          source: /** @type {ol.Coordinate} */ (view.getCenter())
        });
        map.beforeRender(pan);
        view.setCenter(vantaa);

      }, false);

      var panToHelsinki = document.getElementById('helsinki');
      panToHelsinki.addEventListener('click', function() {
        var pan = ol.animation.pan({
          duration: 1200,
          source: /** @type {ol.Coordinate} */ (view.getCenter())
        });
        map.beforeRender(pan);
        view.setCenter(helsinki);

      }, false);
