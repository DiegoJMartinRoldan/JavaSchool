package es.javaschool.springbootosisfinal_task.controllers;
import es.javaschool.springbootosisfinal_task.domain.Client;
import es.javaschool.springbootosisfinal_task.domain.Product;
import es.javaschool.springbootosisfinal_task.dto.ClientDTO;
import es.javaschool.springbootosisfinal_task.dto.ProductDTO;
import es.javaschool.springbootosisfinal_task.exception.ResourceNotFoundException;
import es.javaschool.springbootosisfinal_task.services.productServices.ProductService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("${product.Controller.url}")
public class ProductController {


    @Autowired
    private ProductService productService;


    //List Product
    @GetMapping("/list")
    public String listAll(Model model){
        List<ProductDTO> productDTOS = productService.listAll();

        if (productDTOS == null || productDTOS.isEmpty()){
            throw new ResourceNotFoundException("list");
        }

        model.addAttribute("products", productDTOS);
        return "product/list";
    }


    //Create Product
    @GetMapping("/create")
    public String createPage(Model model){
        ProductDTO productDTO = new ProductDTO();
        model.addAttribute("productCreate", productDTO);
        return "product/create";
    }

    @PostMapping("/create")
    public String createProduct (@Valid ProductDTO productDTO){
        productService.createProduct(productDTO);
        return "redirect:/product/list";

    }


    //Get Product by Id
    @GetMapping("/getby/{id}")
    public String getProductById(@PathVariable Long id, Model model){

        try{
            Product product = productService.getProductById(id);
            model.addAttribute("products", product);
            return "/product/getbyid";
        }catch (EntityNotFoundException exception){
            throw new ResourceNotFoundException("getby","id", id);
        }



    }


    //Update Product
    @GetMapping("/update/{id}")
    public String updatePage(@PathVariable Long id, Model model){

       try{

           Product product = productService.getProductById(id);
           model.addAttribute("products", product);
           return "product/update";

       }catch (EntityNotFoundException exception){
           throw new ResourceNotFoundException("update", "id", id);
       }


    }
    @PostMapping("/update")
    public String Update(@Valid @ModelAttribute("products") ProductDTO productDTO) {
        productService.updateProduct(productDTO);
        return "redirect:/product/list";
    }

    //Delete Clients
    @DeleteMapping("/delete/{id}")
    public String Delete(@PathVariable Long id){
        productService.delete(id);
        return "redirect:/product/list";
    }



}
