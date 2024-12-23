package com.towhid.pointOfSale.service;

import com.towhid.pointOfSale.entity.Branch;
import com.towhid.pointOfSale.entity.Category;
import com.towhid.pointOfSale.entity.Product;
import com.towhid.pointOfSale.entity.Supplier;
import com.towhid.pointOfSale.repository.BranchRepository;
import com.towhid.pointOfSale.repository.CategoryRepository;
import com.towhid.pointOfSale.repository.ProductRepository;
import com.towhid.pointOfSale.repository.SupplierRepository;
import com.towhid.pointOfSale.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private BranchRepository branchRepository;



    @Value("src/main/resources/static/images")
    private String uploadDir;


    public List<Product> getAllProduct() {

        return productRepository.findAll();
    }




    public ApiResponse saveProduct(Product product, MultipartFile imageFile) throws IOException {
        ApiResponse apiResponse = new ApiResponse();

        try {
            // Validate essential fields
            if (product.getName() == null || product.getCategory() == null || product.getBranch() == null) {
                throw new RuntimeException("Product name, category, and branch are required.");
            }

            // Validate and set Category, Supplier, and Branch
            Category category = categoryRepository.findById(product.getCategory().getId())
                    .orElseThrow(() -> new RuntimeException("Category with this id not found."));
            product.setCategory(category);

            Supplier supplier = supplierRepository.findById(product.getSupplier().getId())
                    .orElseThrow(() -> new RuntimeException("Supplier with this id not found."));
            product.setSupplier(supplier);

            Branch branch = branchRepository.findById(product.getBranch().getId())
                    .orElseThrow(() -> new RuntimeException("Branch with this id not found."));
            product.setBranch(branch);

            // Check for existing products with the same name and branch
            List<Product> existingProducts = productRepository.findProductByNameAndBranch(product.getName(), product.getBranch().getBranchName());
            if (!existingProducts.isEmpty()) {
                // Update stock and unit price for existing product
                Product existingProduct = existingProducts.get(0);
                existingProduct.setStock(existingProduct.getStock() + product.getStock());
                existingProduct.setUnitprice(product.getUnitprice());

                // Update image if provided
                if (imageFile != null && !imageFile.isEmpty()) {
                    String imageFileName = saveImage(imageFile, existingProduct);
                    existingProduct.setPhoto(imageFileName);
                }

                productRepository.save(existingProduct);
                apiResponse.setSuccessful(true);
                apiResponse.setMessage("Product already exists in the same branch. Stock updated.");
            } else {
                // Save a new product
                if (imageFile != null && !imageFile.isEmpty()) {
                    String imageFileName = saveImage(imageFile, product);
                    product.setPhoto(imageFileName);
                }

                productRepository.save(product);
                apiResponse.setSuccessful(true);
                apiResponse.setMessage("Product saved successfully.");
            }
        } catch (RuntimeException e) {
            apiResponse.setMessage(e.getMessage());
            apiResponse.setSuccessful(false);
        } catch (Exception e) {
            apiResponse.setMessage("An unexpected error occurred: " + e.getMessage());
            apiResponse.setSuccessful(false);
        }

        return apiResponse;
    }



    public void deleteProductById(int id) {
        productRepository.deleteById(id);
    }

    public Product findProductById(int id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product With This Id Not Found"));
    }



    public List<Product>findProductByCategoryName(String categoryName){
        return productRepository.finndProductByCategoryName(categoryName);
    }

    public List<Product>findProductByName(String productName){
        return productRepository.findProductByName(productName);
    }

    public List<Product> findProductByNameAndBranch(String productName, String branchName) {
        return productRepository.findProductByNameAndBranch(productName, branchName);
    }

    public List<Product>findProductByBranchName(String branchName){
        return productRepository.findProductByBranchName(branchName);
    }


    public Product updateProduct(Product product, int id, MultipartFile file) throws IOException {
        Product existingProduct = this.productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product Not Found"));

        // Update product details
        existingProduct.setName(product.getName());
        existingProduct.setCategory(product.getCategory());
        existingProduct.setUnitprice(product.getUnitprice());
        existingProduct.setQuantity(product.getQuantity());
        existingProduct.setSupplier(product.getSupplier());
        existingProduct.setManufactureDate(product.getManufactureDate());
        existingProduct.setExpiryDate(product.getExpiryDate());

        // Update the stock: Add the incoming stock to the existing stock
        int updatedStock = existingProduct.getStock() + product.getStock(); // Assuming you're adding stock
        existingProduct.setStock(updatedStock);

        // If a new image file is provided, save it
        if (file != null && !file.isEmpty()) {
            String imageFileName = this.saveImage(file, existingProduct);
            existingProduct.setPhoto(imageFileName);
        }

        // Save the updated product
        return this.productRepository.save(existingProduct);
    }





    public String saveImage(MultipartFile file, Product product) throws IOException {
        Path uploadPath = Paths.get(uploadDir + "/product");

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Sanitize file name
        String filename = product.getName().replaceAll("[^a-zA-Z0-9.-]", "_") + "_" + UUID.randomUUID().toString();
        Path filePath = uploadPath.resolve(filename);

        Files.copy(file.getInputStream(), filePath);

        return filename;
    }


    // In ProductService.java
//    public void reduceStock(int productId, int quantity) throws IOException {
//        Product product = findProductById(productId); // Find the product
//        if (product != null) {
//            int newStock = product.getStock() - quantity; // Reduce the stock
//            if (newStock < 0) {
//                throw new IllegalArgumentException("Insufficient stock available");
//            }
//            product.setStock(newStock); // Set the new stock
//            // Save updated product back to the database
//            saveProduct(product, null); // Assuming saveProduct method handles both create and update
//        } else {
//            throw new RuntimeException("Product not found");
//        }
//    }

//    public void reduceStock(int productId, int quantity) throws Exception {
//        // Fetch the product by ID
//        Optional<Product> productOptional = productRepository.findById(productId);
//
//        if (productOptional.isPresent()) {
//            Product product = productOptional.get();
//
//            // Check if the stock is sufficient
//            if (product.getStock() >= quantity) {
//                // Reduce the stock
//                product.setStock(product.getStock() - quantity);
//                // Save the updated product back to the database
//                productRepository.save(product);
//            } else {
//                throw new Exception("Insufficient stock available");
//            }
//        } else {
//            throw new Exception("Product not found");
//        }
//    }


}
