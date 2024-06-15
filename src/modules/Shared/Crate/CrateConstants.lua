local function makeEntry(index: number, tier: number)
	local color = BrickColor.new(index)
	return table.freeze({
		Name = color.Name,
		Color = color.Color,
		Tier = tier,
	})
end

-- https://create.roblox.com/docs/reference/engine/datatypes/BrickColor

return table.freeze({
	makeEntry(1, 1), -- White
	makeEntry(2, 1), -- Grey
	makeEntry(3, 1), -- Light yellow
	makeEntry(5, 1), -- Brick yellow
	makeEntry(6, 1), -- Light green (Mint)
	makeEntry(9, 1), -- Light reddish violet
	makeEntry(11, 4), -- Pastel Blue
	makeEntry(12, 1), -- Light orange brown
	makeEntry(18, 1), -- Nougat
	makeEntry(21, 2), -- Bright red
	makeEntry(22, 2), -- Med. reddish violet
	makeEntry(23, 2), -- Bright blue
	makeEntry(24, 2), -- Bright yellow
	makeEntry(25, 1), -- Earth orange
	makeEntry(26, 1), -- Black
	makeEntry(27, 1), -- Dark grey
	makeEntry(28, 2), -- Dark green
	makeEntry(29, 1), -- Medium green
	makeEntry(36, 1), -- Lig. Yellowich orange
	makeEntry(37, 1), -- Bright green
	makeEntry(38, 1), -- Dark orange
	makeEntry(39, 1), -- Light bluish violet
	makeEntry(40, 3), -- Transparent
	makeEntry(41, 2), -- Tr. Red
	makeEntry(42, 2), -- Tr. Lg blue
	makeEntry(43, 2), -- Tr. Blue
	makeEntry(44, 1), -- Tr. Yellow
	makeEntry(45, 1), -- Light blue
	makeEntry(47, 2), -- Tr. Flu. Reddish orange
	makeEntry(48, 2), -- Tr. Green
	makeEntry(49, 2), -- Tr. Flu. Green
	makeEntry(50, 1), -- Phosph. White
	makeEntry(100, 1), -- Light red
	makeEntry(101, 1), -- Medium red
	makeEntry(102, 1), -- Medium blue
	makeEntry(103, 1), -- Light grey
	makeEntry(104, 3), -- Bright violet
	makeEntry(105, 1), -- Br. yellowish orange
	makeEntry(106, 1), -- Bright orange
	makeEntry(107, 1), -- Bright bluish green
	makeEntry(108, 1), -- Earth yellow
	makeEntry(110, 2), -- Bright bluish violet
	makeEntry(111, 2), -- Tr. Brown
	makeEntry(112, 2), -- Medium bluish violet
	makeEntry(113, 2), -- Tr. Medi. reddish violet
	makeEntry(115, 2), -- Med. yellowish green
	makeEntry(116, 2), -- Med. bluish green
	makeEntry(118, 2), -- Light bluish green
	makeEntry(119, 2), -- Br. yellowish green
	makeEntry(120, 2), -- Lig. yellowish green
	makeEntry(121, 2), -- Med. yellowish orange
	makeEntry(123, 2), -- Br. reddish orange
	makeEntry(124, 2), -- Bright reddish violet
	makeEntry(125, 1), -- Light orange
	makeEntry(126, 1), -- Tr. Bright bluish violet
	makeEntry(127, 1), -- Gold
	makeEntry(128, 1), -- Dark nougat
	makeEntry(131, 1), -- Silver
	makeEntry(133, 1), -- Neon orange
	makeEntry(134, 1), -- Neon green
	makeEntry(135, 1), -- Sand blue
	makeEntry(136, 1), -- Sand violet
	makeEntry(137, 1), -- Medium orange
	makeEntry(138, 1), -- Sand yellow
	makeEntry(140, 1), -- Earth blue
	makeEntry(141, 1), -- Earth green
	makeEntry(143, 1), -- Tr. Flu. Blue
	makeEntry(145, 1), -- Sand blue metallic
	makeEntry(146, 1), -- Sand violet metallic
	makeEntry(147, 1), -- Sand yellow metallic
	makeEntry(148, 1), -- Dark grey metallic
	makeEntry(149, 1), -- Black metallic
	makeEntry(150, 1), -- Light grey metallic
	makeEntry(151, 1), -- Sand green
	makeEntry(153, 1), -- Sand red
	makeEntry(154, 1), -- Dark red
	makeEntry(157, 2), -- Tr. Flu. Yellow
	makeEntry(158, 2), -- Tr. Flu. Red
	makeEntry(168, 1), -- Gun metallic
	makeEntry(176, 1), -- Red flip/flop
	makeEntry(178, 1), -- Yellow flip/flop
	makeEntry(179, 1), -- Silver flip/flop
	makeEntry(180, 1), -- Curry
	makeEntry(190, 2), -- Fire Yellow
	makeEntry(191, 2), -- Flame yellowish orange
	makeEntry(192, 1), -- Reddish brown
	makeEntry(193, 1), -- Flame reddish orange
	makeEntry(194, 1), -- Medium stone grey
	makeEntry(195, 1), -- Royal blue
	makeEntry(196, 1), -- Dark Royal blue
	makeEntry(198, 1), -- Bright reddish lilac
	makeEntry(199, 1), -- Dark stone grey
	makeEntry(200, 1), -- Lemon metalic
	makeEntry(208, 1), -- Light stone grey
	makeEntry(209, 1), -- Dark Curry
	makeEntry(210, 1), -- Faded green
	makeEntry(211, 1), -- Turquoise
	makeEntry(212, 1), -- Light Royal blue
	makeEntry(213, 1), -- Medium Royal blue
	makeEntry(216, 1), -- Rust
	makeEntry(217, 1), -- Brown
	makeEntry(218, 1), -- Reddish lilac
	makeEntry(219, 1), -- Lilac
	makeEntry(220, 1), -- Light lilac
	makeEntry(221, 1), -- Bright purple
	makeEntry(222, 1), -- Light purple
	makeEntry(223, 1), -- Light pink
	makeEntry(224, 1), -- Light brick yellow
	makeEntry(225, 1), -- Warm yellowish orange
	makeEntry(226, 1), -- Cool yellow
	makeEntry(232, 1), -- Dove blue
	makeEntry(268, 1), -- Medium lilac
	makeEntry(301, 1), -- Slime green
	makeEntry(302, 1), -- Smoky grey
	makeEntry(303, 1), -- Dark blue
	makeEntry(304, 1), -- Parsley green
	makeEntry(305, 1), -- Steel blue
	makeEntry(306, 1), -- Storm blue
	makeEntry(307, 3), -- Lapis
	makeEntry(308, 1), -- Dark indigo
	makeEntry(309, 1), -- Sea green
	makeEntry(310, 1), -- Shamrock
	makeEntry(311, 1), -- Fossil
	makeEntry(312, 1), -- Mulberry
	makeEntry(313, 1), -- Forest green
	makeEntry(314, 1), -- Cadet blue
	makeEntry(315, 3), -- Electric blue
	makeEntry(316, 3), -- Eggplant
	makeEntry(317, 1), -- Moss
	makeEntry(318, 1), -- Artichoke
	makeEntry(319, 1), -- Sage green
	makeEntry(320, 1), -- Ghost grey
	makeEntry(321, 1), -- Lilac
	makeEntry(322, 1), -- Plum
	makeEntry(323, 1), -- Olivine
	makeEntry(324, 1), -- Laurel green
	makeEntry(325, 1), -- Quill grey
	makeEntry(327, 3), -- Crimson
	makeEntry(328, 1), -- Mint
	makeEntry(329, 1), -- Baby blue
	makeEntry(330, 1), -- Carnation pink
	makeEntry(331, 2), -- Persimmon
	makeEntry(332, 3), -- Maroon
	makeEntry(333, 3), -- Gold
	makeEntry(334, 1), -- Daisy orange
	makeEntry(335, 1), -- Pearl
	makeEntry(336, 1), -- Fog
	makeEntry(337, 1), -- Salmon
	makeEntry(338, 1), -- Terra Cotta
	makeEntry(339, 1), -- Cocoa
	makeEntry(340, 1), -- Wheat
	makeEntry(341, 1), -- Buttermilk
	makeEntry(342, 1), -- Mauve
	makeEntry(343, 1), -- Sunrise
	makeEntry(344, 1), -- Tawny
	makeEntry(345, 1), -- Rust
	makeEntry(346, 1), -- Cashmere
	makeEntry(347, 1), -- Khaki
	makeEntry(348, 1), -- Lily white
	makeEntry(349, 1), -- Seashell
	makeEntry(350, 1), -- Burgundy
	makeEntry(351, 1), -- Cork
	makeEntry(352, 1), -- Burlap
	makeEntry(353, 1), -- Beige
	makeEntry(354, 1), -- Oyster
	makeEntry(355, 1), -- Pine Cone
	makeEntry(356, 1), -- Fawn brown
	makeEntry(357, 1), -- Hurricane grey
	makeEntry(358, 1), -- Cloudy grey
	makeEntry(359, 1), -- Linen
	makeEntry(360, 1), -- Copper
	makeEntry(361, 1), -- Medium brown
	makeEntry(362, 1), -- Bronze
	makeEntry(363, 1), -- Flint
	makeEntry(364, 1), -- Dark taupe
	makeEntry(365, 1), -- Burnt Sienna
	makeEntry(1001, 1), -- Institutional white
	makeEntry(1002, 1), -- Mid gray
	makeEntry(1003, 3), -- Really black
	makeEntry(1004, 3), -- Really red
	makeEntry(1005, 2), -- Deep orange
	makeEntry(1006, 2), -- Alder
	makeEntry(1007, 1), -- Dusty Rose
	makeEntry(1008, 1), -- Olive
	makeEntry(1009, 3), -- New Yeller
	makeEntry(1010, 3), -- Really blue
	makeEntry(1011, 1), -- Navy blue
	makeEntry(1012, 2), -- Deep blue
	makeEntry(1013, 3), -- Cyan
	makeEntry(1014, 1), -- CGA brown
	makeEntry(1015, 3), -- Magenta
	makeEntry(1016, 3), -- Pink
	makeEntry(1017, 2), -- Deep orange
	makeEntry(1018, 2), -- Teal
	makeEntry(1019, 2), -- Toothpaste
	makeEntry(1020, 1), -- Lime green
	makeEntry(1021, 1), -- Camo
	makeEntry(1022, 1), -- Grime
	makeEntry(1023, 1), -- Lavender
	makeEntry(1024, 4), -- Pastel light blue
	makeEntry(1025, 4), -- Pastel orange
	makeEntry(1026, 4), -- Pastel violet
	makeEntry(1027, 4), -- Pastel blue-green
	makeEntry(1028, 4), -- Pastel green
	makeEntry(1029, 4), -- Pastel yellow
	makeEntry(1030, 4), -- Pastel brown
	makeEntry(1031, 3), -- Royal purple
	makeEntry(1032, 3), -- Hot pink
})
