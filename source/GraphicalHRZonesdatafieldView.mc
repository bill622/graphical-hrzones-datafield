import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.UserProfile;

class GraphicalHRZonesdatafieldView extends WatchUi.DataField {

    hidden var mCurrentHr as Numeric;
    hidden var hrZones as Array;
    hidden var restingHr as Numeric;

    function initialize() {
        DataField.initialize();
        mCurrentHr = 0.0f;
        var profile = UserProfile.getProfile();
        var sport = UserProfile.getCurrentSport();
        hrZones = UserProfile.getHeartRateZones(sport);
        restingHr = profile.restingHeartRate;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
        }

        (View.findDrawableById("label") as Text).setText(Rez.Strings.label);
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                mCurrentHr = info.currentHeartRate as Number;
            } else {
                mCurrentHr = 0;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the foreground color and value
        /*var value = View.findDrawableById("label") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }*/
        var indicator = getIndicator();                
        value.setText( "" );
        //value.setText( mCurrentHr.toString() + " " + indicator[0].toString() + " " + indicator[1].toString() );

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    function getIndicator() {
        var output = [0, 0];
        if( mCurrentHr < hrZones[0]){
            //Zone lazy
            output[0] = 0;
            output[1] = getSubdivisions( restingHr, hrZones[0]);
        } else if( mCurrentHr >= hrZones[0] && mCurrentHr < hrZones[1] ) {
            //Zone 1
            output[0] = 1;
            output[1] = getSubdivisions( hrZones[0], hrZones[1]);
        } else if( mCurrentHr >= hrZones[1] && mCurrentHr < hrZones[2] ) {
            //Zone 2
            output[0] = 2;
            output[1] = getSubdivisions( hrZones[1], hrZones[2]);
        } else if( mCurrentHr >= hrZones[2] && mCurrentHr < hrZones[3] ) {
            //Zone 3
            output[0] = 3;
            output[1] = getSubdivisions( hrZones[2], hrZones[3]);
        } else if( mCurrentHr >= hrZones[3] && mCurrentHr < hrZones[4] ) {
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
        if( mCurrentHr < hrZoneMin ) {
            return 0;
        } else if( mCurrentHr >= hrZoneMin && mCurrentHr < step1 ) {
            return 1;
        } else if( mCurrentHr >= step1 && mCurrentHr < step2 ) {
            return 2;
        } else if( mCurrentHr >= step2 && mCurrentHr < step3 ) {
            return 3;
        } else if( mCurrentHr >= step3 && mCurrentHr < step4 ) {
            return 4;
        } else {
            return 5;
        }
    }


}