class ProductCategory {
  final String name;
  final List<String> subcategories;

  ProductCategory({
    required this.name,
    required this.subcategories,
  });

  // Factory method to create a ProductCategory from JSON
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'] as String,
      subcategories: List<String>.from(json['subcategories'] as List),
    );
  }

  // Method to convert a ProductCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subcategories': subcategories,
    };
  }
}



  final List<ProductCategory> productCategories = [
    ProductCategory(
      name: 'Plastic Products',
      subcategories: [
        'Pipes and Fittings',
        'Water Tanks',
        'Water Taps',
        'Septic Tanks',
        'Carbuoys',
        'Plastic Films',
        'Pots',
        'Plastic Moulded Items',
        'Plastic Containers',
      ],
    ),
    ProductCategory(
      name: 'Building Materials',
      subcategories: [
        'Multiwood',
        'Door and Window Frames',
        'Structural Building',
        'Designer Tiles and Paver Blocks',
        'Rolling Shutters',
        'Paints',
        'Clay Tile',
      ],
    ),
    ProductCategory(
      name: 'Rubber Products',
      subcategories: [
        'Tread Rubber',
        'Rubber Moulds',
        'Conveyor Belts',
      ],
    ),
    ProductCategory(
      name: 'Stationery',
      subcategories: [
        'Printing Paper',
        'Writing Pen',
      ],
    ),
    ProductCategory(
      name: 'Agricultural Products',
      subcategories: [
        'Manure',
        'Rainguard Materials',
      ],
    ),
    ProductCategory(
      name: 'Packing Materials',
      subcategories: [
        'Carton Box',
        'Plywood Packing',
      ],
    ),
    ProductCategory(
      name: 'Household Items',
      subcategories: [
        'Chairs',
        'Pet Cages',
      ],
    ),
    ProductCategory(
      name: 'Safety Products',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Chemicals',
      subcategories: [
        'Cleaning Chemicals',
        'Water Treatment Chemicals',
        'Industrial Chemicals',
        'Soaps and Detergents',
        'Varnishes',
        'Solvents',
      ],
    ),
    ProductCategory(
      name: 'Industrial Oils',
      subcategories: [
        'Machine Oil',
        'Hydraulic Oil',
      ],
    ),
    ProductCategory(
      name: 'Machinery',
      subcategories: [
        'Food Processing Machinery',
        'Electrical Machinery',
        'Crusher Machinery',
        'Packing Machines',
        'Industrial Heaters',
        'Industrial Ovens',
        'Clay Tile Machinery',
        'Wood Machines',
        'Printing Machinery',
        'Boilers, Heaters, Chimneys',
        'Rubber Machinery',
      ],
    ),
    ProductCategory(
      name: 'Machine Shop',
      subcategories: [
        'Dies',
        'CNC Works',
        'Lathe Work',
      ],
    ),
    ProductCategory(
      name: 'Industrial Adhesive',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Dresses',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Food Products',
      subcategories: [
        'Packaged Food Products',
        'Packaged Snacks',
        'Cooking Oil',
      ],
    ),
    ProductCategory(
      name: 'Electroplating',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Health Care Products',
      subcategories: [
        'Cosmetic Products',
        'Ayurvedic Products',
        'Soaps',
        'Toothpaste',
      ],
    ),
    ProductCategory(
      name: 'Welding Materials',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Milk and Milk Products',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Industrial Gas',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Aluminium Products',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Steel Products',
      subcategories: [],
    ),
    ProductCategory(
      name: 'Electrical Products',
      subcategories: [
        'Electrical Switches',
        'Panel Boards',
        'Earthing Equipment',
        'Wiring Cables',
      ],
    ),
    ProductCategory(
      name: 'Electronic Products',
      subcategories: [],
    ),
  ];