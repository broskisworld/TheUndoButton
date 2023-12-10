$fn = 50;

// dimensions
plate_w = 100;
plate_d = 140;
plate_h = 3;
plate_rounding_rad = 1.5;
brace_wall_inset = 4;
brace_wall_h = 2;
brace_wall_w = 1.5;
btn_w = 5.98;
btn_d = 5.98;
btn_h = 3.85;
btn_press_diam = 3.4;
pot_outer_h = 10;
pot_outer_diam = 60;
pot_mounting_diam = 55;
pot_inner_diam = 40;
pot_inner_h = 20;
pot_mounting_hole_diam = 3.5;
status_panel_inset = 6;
status_panel_h = 2;
status_panel_rounding_rad = 2;

// plate
plate_h1 = plate_rounding_rad;
plate_h2 = plate_h - plate_rounding_rad;

module plate() {
    difference() {
        union() {
            plate_base();
        }
        union() {
            plate_mounting_holes();
        }
    }
}

// main plate
module plate_base() {
    intersection() {
        translate([0, 0, (0.5 * plate_h) - plate_rounding_rad]) {
            minkowski() {
                cube([plate_w - (2 * plate_rounding_rad), plate_d - (2 * plate_rounding_rad), plate_h], center=true);
                sphere(r=plate_rounding_rad);
            }
        }
        translate([0, 0, plate_h / 2]) cube([plate_w, plate_d, plate_h], center=true);
    }
}

module pot_mounting_holes() {
    translate([0, 0, -0.5 * plate_h]) {
        for (i = [0:3]) {
            rotate([0, 0, i * 90]) {
                translate([0, 0, 0.5 * pot_mounting_hole_diam]) {
                    cylinder(r=pot_mounting_hole_diam / 2, h=plate_h, center=true);
                }
            }
        }
    }
}

plate();