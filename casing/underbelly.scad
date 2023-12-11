$fn = 50;

// dimensions
plate_w = 100;
plate_d = 140;
plate_h = 3;
plate_rounding_rad = 1.5;
brace_wall_inset = 4;
brace_wall_h = 2;
brace_wall_w = 1.5;
key_inset = 8;
key_w = 15.9;
key_d = 25;
key_d2 = 25.6;
key_d2_offset = key_d2 - key_d;
key_h = 1.5;
key_spacing = 4;
btn_w = 5.98;
btn_d = 5.98;
btn_h = 3.85;
btn_wall_h = 2;
btn_wall_w = 1.5;
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
            key_walls();
        }
        union() {
            pot_mounting_holes();
            pot_inner();
            plate_btns();
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
        for (i = [0:2]) {
            rotate([0, 0, 90 + (i * 120)]) {
                translate([pot_mounting_diam / 2, 0, 0.5 * pot_mounting_hole_diam]) {
                    cylinder(r=pot_mounting_hole_diam / 2, h=plate_h * 10, center=true);
                }
            }
        }
    }
}

module pot_inner() {
    translate([0, 0, .5 * plate_h]) {
        cylinder(r=pot_inner_diam / 2, h=2 * plate_h, center=true);
    }
}

module plate_btns() {
    bottom_left = [(-0.5 * plate_w) + (0.5 * key_w) + key_inset, (-0.5 * plate_d) + (0.5 * key_d2) + key_inset, (plate_h) - (0.5 * key_h) ];
    bottom_right = [(0.5 * plate_w) - (0.5 * key_w) - key_inset, (-0.5 * plate_d) + (0.5 * key_d2) + key_inset, (plate_h) - (0.5 * key_h) ];
    translate(bottom_left + [0, 0, 0])
        key();
    translate(bottom_right + [0, 0, 0])
        key();
    translate(bottom_right + [-key_w - key_spacing, 0, 0])
        key();
}

module key() {
    cube([key_w, key_d2, key_h], center=true);
        translate([0, (-0.5 * key_d) + (-0.5 * (key_d2_offset)), 0])
            scale([(0.5 * key_w) / key_d2_offset, 1, 1])
                cylinder(r=key_d2_offset, h=key_h, center=true);
    translate([0, 0, (-.5 * btn_h) - (0.5 * key_h) + .0001])
        % cube([btn_w, btn_d, btn_h], center=true);
}

module key_walls() {
    bottom_left = [(-0.5 * plate_w) + (0.5 * key_w) + key_inset, (-0.5 * plate_d) + (0.5 * key_d2) + key_inset, (plate_h) - (0.5 * key_h) ];
    bottom_right = [(0.5 * plate_w) - (0.5 * key_w) - key_inset, (-0.5 * plate_d) + (0.5 * key_d2) + key_inset, (plate_h) - (0.5 * key_h) ];
    // translate(bottom_left + [0, 0, 0])
    //     // key();
    // translate(bottom_right + [0, 0, 0])
        // key();
    translate(bottom_right + [-key_w - key_spacing, 0, 0]) {
        translate([0, 0, (-1 * btn_wall_h) - (0.5 * plate_h) + 0.1]) {
            cube([btn_wall_w, btn_wall_w, btn_wall_h], center=true);
        }
    }
}

module btn_cube() {
    translate([0, 0, -0.5 * btn_h])
        cube([btn_w, btn_d, btn_h], center=true);
    
}

plate();