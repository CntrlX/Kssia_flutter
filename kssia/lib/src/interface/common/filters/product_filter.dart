import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/models/product_category_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/selection_drop_down.dart';

class ShowProductFilter extends StatefulWidget {
  ShowProductFilter({
    super.key,
  });

  @override
  State<ShowProductFilter> createState() => _ShowProductFilterState();
}

class _ShowProductFilterState extends State<ShowProductFilter> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  String? selectedSubCategory;
  @override
  Widget build(BuildContext context) {
    List<String> subCategories = productCategories
        .where((category) => category.name == selectedCategory)
        .map((category) => category.subcategories)
        .expand((sub) => sub) // Flatten the list of lists
        .toList();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final asyncCategories =
                      ref.watch(fetchProductCategoriesProvider);
                  return asyncCategories.when(
                    data: (categoryCountList) {
                      // Ensure the categoryCountList is of type List<ProductCategoryModel>
                      return SelectionDropDown(
                        hintText: 'Select Category',
                        value: selectedCategory,
                        items: productCategories
                            .map<DropdownMenuItem<String>>((category) {
                          // Find matching count from categoryCountList
                          final matchingCategory = categoryCountList.firstWhere(
                            (categoryModel) =>
                                categoryModel.name == category.name,
                            orElse: () => ProductCategoryModel(
                              count: 0,
                              name: category.name,
                              subcategories: category.subcategories
                                  .map((sub) => SubcategoryModel(count: 0))
                                  .toList(),
                            ),
                          );

                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(category.name), // Category name
                                Text(
                                    style: TextStyle(color: Colors.blue),
                                    '(${matchingCategory.count})'), // Category count
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
                    },
                    loading: () => Center(child: LoadingAnimation()),
                    error: (error, stackTrace) {
                      return Center(
                        child: Text('Couldn\'t fetch categories'),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              if (subCategories.isNotEmpty)
                Consumer(
                  builder: (context, ref, child) {
                    final asyncCategories =
                        ref.watch(fetchProductCategoriesProvider);
                    return asyncCategories.when(
                      data: (categoryCountList) {
                        // Find the matching category to get subcategory counts
                        final matchingCategory = categoryCountList.firstWhere(
                          (cat) => cat.name == selectedCategory,
                          orElse: () => ProductCategoryModel(
                            count: 0,
                            name: selectedCategory ?? '',
                            subcategories: List.generate(
                              subCategories.length,
                              (index) => SubcategoryModel(count: 0),
                            ),
                          ),
                        );

                        return SelectionDropDown(
                          hintText: 'Sub Category',
                          value: selectedSubCategory,
                          items: subCategories.map((subCategory) {
                            // Find the matching subcategory from ProductCategory model
                            final categoryIndex = productCategories.indexWhere(
                                (cat) => cat.name == selectedCategory);

                            if (categoryIndex == -1)
                              return DropdownMenuItem<String>(
                                value: subCategory,
                                child: Text(subCategory),
                              );

                            // Find the subcategory index in the original ProductCategory model
                            final subCategoryIndex =
                                productCategories[categoryIndex]
                                    .subcategories
                                    .indexOf(subCategory);

                            // Get the count from the matching category's subcategories
                            final subCount = subCategoryIndex <
                                    matchingCategory.subcategories.length
                                ? matchingCategory
                                    .subcategories[subCategoryIndex].count
                                : 0;

                            return DropdownMenuItem<String>(
                              value: subCategory,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(subCategory),
                                  Text(
                                    '($subCount)',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubCategory = value;
                            });
                          },
                        );
                      },
                      loading: () => Center(child: LoadingAnimation()),
                      error: (error, stackTrace) {
                        return SelectionDropDown(
                          hintText: 'Sub Category',
                          value: selectedSubCategory,
                          items: subCategories.map((subCategory) {
                            return DropdownMenuItem<String>(
                              value: subCategory,
                              child: Text(subCategory),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubCategory = value;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 10),
              customButton(
                label: 'SEARCH PRODUCTS',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final mapData = {
                      'selectedCategory': selectedCategory ?? '',
                      'selectedSubCategory': selectedSubCategory ?? '',
                    };

                    Navigator.pop(context, mapData);
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
