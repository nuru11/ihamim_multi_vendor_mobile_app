import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihamim_multivendor/app/controllers/categroy_controller.dart';
import 'package:ihamim_multivendor/app/controllers/product_controller.dart';
import 'package:ihamim_multivendor/app/utils/constants/colors.dart';


class FilterBottomSheet extends StatelessWidget {
  final ProductController productController;
  final CategoryController categoryController;

  const FilterBottomSheet({
    super.key,
    required this.productController,
    required this.categoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const Text(
                "Filter Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 🔹 Price Range
              const Text("Price Range", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Min",
                        prefixText: "ETB ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) {
                        productController.minPrice.value = double.tryParse(val) ?? 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Max",
                        prefixText: "ETB ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) {
                        productController.maxPrice.value = double.tryParse(val) ?? 1000000;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Category
              const Text("Category", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text("Select Category"),
                  value: productController.selectedCategory.value,
                  items: categoryController.categories
                      .map((cat) => DropdownMenuItem(
                            value: cat.categoryName,
                            child: Text(cat.categoryName ?? "Unknown"),
                          ))
                      .toList(),
                  onChanged: (val) => productController.selectedCategory.value = val,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Condition
              const Text("Condition", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text("Choose Condition"),
                  value: productController.condition.value,
                  items: ["new", "used"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => productController.condition.value = val,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Sort
              const Text("Sort By", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: productController.sortBy.value,
                  items: const [
                    DropdownMenuItem(value: "popular", child: Text("Popular")),
                    DropdownMenuItem(value: "urgent", child: Text("Urgent")),
                    DropdownMenuItem(value: "high", child: Text("Price: High to Low")),
                    DropdownMenuItem(value: "low", child: Text("Price: Low to High")),
                  ],
                  onChanged: (val) => productController.sortBy.value = val ?? "popular",
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Reset filters
                        productController.selectedCategory.value = null;
                        productController.condition.value = null;
                        productController.minPrice.value = 0;
                        productController.maxPrice.value = 1000000;
                        productController.sortBy.value = "popular";
                        productController.applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Clear Filters"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: mainColor,
                      ),
                      onPressed: () {
                        productController.applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filters",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }



  

}
