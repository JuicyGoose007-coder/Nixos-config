{ ... }:
{
  text = ''

    output "DP-2" {
    	position x=1920 y=0
    	mode "2560x1440@164.999" 
    	scale 1 
    	focus-at-startup
    }

    output "DP-1" {
    	position x=0 y=0
    	mode "1920x1080@60.000"
    	scale 1
    }


    gestures {
        hot-corners {
            off
        }
    }
  '';
}
