import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.UserProfile;

class GraphicalHRZonesdatafieldView extends WatchUi.DataField {

    hidden var SCREEN_SIZE = 218;       // Originaly made for Fenix3
    hidden var currentHr as Numeric;
    hidden var hrZones as Array;
    hidden var restingHr as Numeric;
    hidden var indicatorX as Numeric;
    hidden var indicatorY as Numeric;

    function initialize() {
        DataField.initialize();
        currentHr = 0.0f;
        var profile = UserProfile.getProfile();
        var sport = UserProfile.getCurrentSport();
        hrZones = UserProfile.getHeartRateZones(sport);
        restingHr = profile.restingHeartRate;

        SCREEN_SIZE = System.getDeviceSettings().screenWidth;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            indicatorX = ( SCREEN_SIZE / 4 ) - 47;
            indicatorY = ( SCREEN_SIZE / 4 ) + 10;
        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            indicatorX = ( SCREEN_SIZE / 4 ) - 50;
            indicatorY = ( SCREEN_SIZE / 4 ) + 10;
        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            indicatorX = ( SCREEN_SIZE / 4 ) - 48;
            indicatorY = 8;
        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            indicatorX = ( SCREEN_SIZE / 4 ) - 50;
            indicatorY = 8 ;
        // 2 fields layout - TOP
        } else if (obscurityFlags == ( OBSCURE_LEFT | OBSCURE_RIGHT | OBSCURE_TOP )) {
            indicatorX = ( SCREEN_SIZE / 2 ) - 50;
            indicatorY = ( SCREEN_SIZE / 6 ) - 10;
        // 2 fields layout - BOTTOM
        } else if (obscurityFlags == ( OBSCURE_LEFT | OBSCURE_RIGHT | OBSCURE_BOTTOM )) {
            indicatorX = ( SCREEN_SIZE / 2 ) - 50;
            indicatorY = ( SCREEN_SIZE / 6 ) - 25 ;
        // 3 rows fields layout - MIDDLE
        } else if (obscurityFlags == ( OBSCURE_LEFT | OBSCURE_RIGHT )) {
            indicatorX = ( SCREEN_SIZE / 2 ) - 50;
            indicatorY = ( SCREEN_SIZE / 6 ) - 10;
        // 4 fields in 3 rows layout - MIDDLE LEFT
        } else if (obscurityFlags == ( OBSCURE_LEFT )) {
            indicatorX = ( SCREEN_SIZE / 4 ) - 50;
            indicatorY = ( SCREEN_SIZE / 6 ) - 10;
        // 4 fields in 3 rows layout - MIDDLE RIGHT
        } else if (obscurityFlags == ( OBSCURE_RIGHT )) {
            indicatorX = ( SCREEN_SIZE / 4 ) - 50;
            indicatorY = ( SCREEN_SIZE / 6 ) - 10;
        // 1 field full screen
        } else {
            indicatorX = ( SCREEN_SIZE / 2) - 50;
            indicatorY = ( SCREEN_SIZE / 2) - 11;
        }
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                currentHr = info.currentHeartRate as Number;
            } else {
                currentHr = 0;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        var indicator = getIndicator();
        var percent = getPercentMaxHr();
        
        // Call parent's onUpdate(dc) to redraw the layout
        //View.onUpdate(dc);
        dc.setColor( getBackgroundColor(), getBackgroundColor() );
        dc.clear();
        drawIndicator( dc, indicator, indicatorX, indicatorY );
        writeZone( dc, indicator, indicatorX, indicatorY );
        writePercent( dc, percent, indicatorX, indicatorY );
    }

    function drawIndicator( dc, indicator, blockX, blockY ) {
        var block1Color = Graphics.COLOR_TRANSPARENT;
        var block2Color = Graphics.COLOR_TRANSPARENT;
        var block3Color = Graphics.COLOR_TRANSPARENT;
        var block4Color = Graphics.COLOR_TRANSPARENT;
        
        if ( indicator[0] == 1 ) {
            if( indicator[1] == 1 ){
                block1Color = Graphics.COLOR_LT_GRAY;
            } else if( indicator[1] == 2 ){
                block1Color = Graphics.COLOR_LT_GRAY;
                block2Color = Graphics.COLOR_LT_GRAY;
            } else if( indicator[1] == 3 ){
                block1Color = Graphics.COLOR_LT_GRAY;
                block2Color = Graphics.COLOR_LT_GRAY;
                block3Color = Graphics.COLOR_LT_GRAY;
            } else if( indicator[1] == 4 ){
                block1Color = Graphics.COLOR_LT_GRAY;
                block2Color = Graphics.COLOR_LT_GRAY;
                block3Color = Graphics.COLOR_LT_GRAY;
                block4Color = Graphics.COLOR_LT_GRAY;
            }
        } else if ( indicator[0] == 2 ) {
            if( indicator[1] == 1 ){
                block1Color = Graphics.COLOR_BLUE;
            } else if( indicator[1] == 2 ){
                block1Color = Graphics.COLOR_BLUE;
                block2Color = Graphics.COLOR_BLUE;
            } else if( indicator[1] == 3 ){
                block1Color = Graphics.COLOR_BLUE;
                block2Color = Graphics.COLOR_BLUE;
                block3Color = Graphics.COLOR_BLUE;
            } else if( indicator[1] == 4 ){
                block1Color = Graphics.COLOR_BLUE;
                block2Color = Graphics.COLOR_BLUE;
                block3Color = Graphics.COLOR_BLUE;
                block4Color = Graphics.COLOR_BLUE;
            }
        } else if ( indicator[0] == 3 ) {
            if( indicator[1] == 1 ){
                block1Color = Graphics.COLOR_GREEN;
            } else if( indicator[1] == 2 ){
                block1Color = Graphics.COLOR_GREEN;
                block2Color = Graphics.COLOR_GREEN;
            } else if( indicator[1] == 3 ){
                block1Color = Graphics.COLOR_GREEN;
                block2Color = Graphics.COLOR_GREEN;
                block3Color = Graphics.COLOR_GREEN;
            } else if( indicator[1] == 4 ){
                block1Color = Graphics.COLOR_GREEN;
                block2Color = Graphics.COLOR_GREEN;
                block3Color = Graphics.COLOR_GREEN;
                block4Color = Graphics.COLOR_GREEN;
            }
        } else if ( indicator[0] == 4 ) {
            if( indicator[1] == 1 ){
                block1Color = Graphics.COLOR_ORANGE;
            } else if( indicator[1] == 2 ){
                block1Color = Graphics.COLOR_ORANGE;
                block2Color = Graphics.COLOR_ORANGE;
            } else if( indicator[1] == 3 ){
                block1Color = Graphics.COLOR_ORANGE;
                block2Color = Graphics.COLOR_ORANGE;
                block3Color = Graphics.COLOR_ORANGE;
            } else if( indicator[1] == 4 ){
                block1Color = Graphics.COLOR_ORANGE;
                block2Color = Graphics.COLOR_ORANGE;
                block3Color = Graphics.COLOR_ORANGE;
                block4Color = Graphics.COLOR_ORANGE;
            }
        } else if ( indicator[0] == 5 ) {
            if( indicator[1] == 1 ){
                block1Color = Graphics.COLOR_RED;
            } else if( indicator[1] == 2 ){
                block1Color = Graphics.COLOR_RED;
                block2Color = Graphics.COLOR_RED;
            } else if( indicator[1] == 3 ){
                block1Color = Graphics.COLOR_RED;
                block2Color = Graphics.COLOR_RED;
                block3Color = Graphics.COLOR_RED;
            } else if( indicator[1] == 4 ){
                block1Color = Graphics.COLOR_RED;
                block2Color = Graphics.COLOR_RED;
                block3Color = Graphics.COLOR_RED;
                block4Color = Graphics.COLOR_RED;
            }
        }

        // Indicators Frame
        dc.setColor( Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT );
        dc.drawRectangle( blockX, blockY, 23, 23 );
        dc.drawRectangle( blockX + 25, blockY, 23, 23 );
        dc.drawRectangle( blockX + 50, blockY, 23, 23 );
        dc.drawRectangle( blockX + 75, blockY, 23, 23 );

        // Indicators
        dc.setColor( block1Color, block1Color );
        dc.fillRectangle( blockX, blockY, 23, 23 );
        dc.setColor( block2Color, block2Color );
        dc.fillRectangle( blockX + 25, blockY, 23, 23 );
        dc.setColor( block3Color, block3Color );
        dc.fillRectangle( blockX + 50, blockY, 23, 23 );
        dc.setColor( block4Color, block4Color );
        dc.fillRectangle( blockX + 75, blockY, 23, 23 );
    }

    function writeZone( dc, indicator, blockX, blockY ) {
        var text = "";
        if( indicator[0] != 0 ) {
            text = "z " + indicator[0];
        }
        if( getBackgroundColor() == Graphics.COLOR_BLACK ){
            dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_BLACK );
        } else {
            dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_WHITE );
        }

        dc.drawText( blockX,
                     blockY + 22,
                     Graphics.FONT_TINY,
                     text,
                     Graphics.TEXT_JUSTIFY_LEFT
                    );
    }

    function writePercent( dc, percent, blockX, blockY ) {
        var text = "";
        var fgColor = 0;
        var bgColor = Graphics.COLOR_TRANSPARENT;
        if( percent >= 15 ) {
            text = percent.format( "%.0f") + " %";
        }
        if( getBackgroundColor() == Graphics.COLOR_BLACK ){
            fgColor = Graphics.COLOR_TRANSPARENT;
        } else {
            if( percent < 80 ) {
                fgColor = Graphics.COLOR_BLUE;
            } else if( percent >= 80 && percent < 87 ) {
                fgColor = Graphics.COLOR_BLACK;
            } else {
                fgColor = Graphics.COLOR_RED;
            }
            
        }
        dc.setColor( fgColor, bgColor );
        dc.drawText( blockX + 100,
                     blockY + 22,
                     Graphics.FONT_TINY,
                     text,
                     Graphics.TEXT_JUSTIFY_RIGHT
                    );
    }

    function getIndicator() {
        var output = [0, 0];
        if( currentHr < hrZones[0]){
            //Zone lazy
            output[0] = 0;
            output[1] = getSubdivisions( restingHr, hrZones[0]);
        } else if( currentHr >= hrZones[0] && currentHr < hrZones[1] ) {
            //Zone 1
            output[0] = 1;
            output[1] = getSubdivisions( hrZones[0], hrZones[1]);
        } else if( currentHr >= hrZones[1] && currentHr < hrZones[2] ) {
            //Zone 2
            output[0] = 2;
            output[1] = getSubdivisions( hrZones[1], hrZones[2]);
        } else if( currentHr >= hrZones[2] && currentHr < hrZones[3] ) {
            //Zone 3
            output[0] = 3;
            output[1] = getSubdivisions( hrZones[2], hrZones[3]);
        } else if( currentHr >= hrZones[3] && currentHr < hrZones[4] ) {
            //Zone 4
            output[0] = 4;
            output[1] = getSubdivisions( hrZones[3], hrZones[4]);
        } else {
            //Zone 5
            output[0] = 5;
            output[1] = getSubdivisions( hrZones[4], hrZones[5]);
        }
            
        return output;
    }

    function getSubdivisions( hrZoneMin, hrZoneMax ) {
        var hrZoneDiff = hrZoneMax - hrZoneMin;
        var step1 = hrZoneMin + ( hrZoneDiff * 0.25 );
        var step2 = hrZoneMin + ( hrZoneDiff * 0.50 );
        var step3 = hrZoneMin + ( hrZoneDiff * 0.75 );
        var step4 = hrZoneMax;
        if( currentHr < hrZoneMin ) {
            return 0;
        } else if( currentHr >= hrZoneMin && currentHr < step1 ) {
            return 1;
        } else if( currentHr >= step1 && currentHr < step2 ) {
            return 2;
        } else if( currentHr >= step2 && currentHr < step3 ) {
            return 3;
        } else if( currentHr >= step3 && currentHr < step4 ) {
            return 4;
        } else {
            return 0;
        }
    }

    function getPercentMaxHr() {
        return 100 * ( currentHr.toFloat() / hrZones[5].toFloat() );
    }
}