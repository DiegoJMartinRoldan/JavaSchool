package es.javaschool.springbootosisfinal_task.services;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import es.javaschool.springbootosisfinal_task.domain.Client;
import es.javaschool.springbootosisfinal_task.domain.OrderHasProduct;
import es.javaschool.springbootosisfinal_task.domain.Orders;
import es.javaschool.springbootosisfinal_task.domain.Product;
import es.javaschool.springbootosisfinal_task.dto.CartProductDTO;
import es.javaschool.springbootosisfinal_task.dto.OrdersDTO;
import es.javaschool.springbootosisfinal_task.dto.ProductDTO;
import es.javaschool.springbootosisfinal_task.repositories.OrderHasProductRepository;
import es.javaschool.springbootosisfinal_task.services.clientAddresServices.ClientAddressService;
import es.javaschool.springbootosisfinal_task.services.clientServices.ClientService;
import es.javaschool.springbootosisfinal_task.services.ordersServices.OrdersService;
import es.javaschool.springbootosisfinal_task.services.productServices.ProductService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

@Service
public class ShoppingCartService {

    private static final Logger log = LoggerFactory.getLogger(ShoppingCartService.class);

    @Autowired
    private ClientService clientService;

    @Autowired
    private OrdersService ordersService;

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderHasProductRepository orderHasProductRepository;

    @Autowired
    private ClientAddressService clientAddressService;

    // Add to cart for authenticated and no authenticated users
    public void addToCart(CartProductDTO cartProductDTO, HttpServletResponse response) {
        Long clientId = cartProductDTO.getClientId();
        Long clientAddressId = cartProductDTO.getClientAddressId();

        if (clientId != null && clientAddressId != null) {
            // Usuario autenticado
            log.info("Authenticated user. ClientId: {} ", clientId);
            log.info("Authenticated user. ClientAddressId: {} ", clientAddressId);
            handleAuthenticatedUser(clientId, clientAddressId, cartProductDTO);
        } else {
            // Usuario no autenticado
            log.info("Unauthenticated user.");
            handleUnAuthenticatedUser(cartProductDTO, response);
        }
    }



    // Authenticated
    private void handleAuthenticatedUser(Long clientId, Long clientAddressId, CartProductDTO cartProductDTO) {

        OrdersDTO ordersDTO = new OrdersDTO();

        ordersDTO.setClient(clientService.getClientById(clientId));
        ordersDTO.setClientsAddress(clientAddressService.getClientAddressById(clientAddressId));
        ordersDTO.setOrderStatus("PENDING");

        Date currentDate = Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant());
        ordersDTO.setOrderDate(currentDate);


        Orders newOrder = ordersService.createOrder(ordersDTO);


       connectProductToOrders(newOrder, cartProductDTO.getProducts(), cartProductDTO.getQuantities());
    }

    //Not authenticated
    private void handleUnAuthenticatedUser(CartProductDTO cartProductDTO, HttpServletResponse httpServletResponse) {
        connectProductToCookie(cartProductDTO, httpServletResponse);
    }

    // Product - Order
     private void connectProductToOrders(Orders orders, List<ProductDTO> productDTOList, List<Integer> quantities) {
         for (int i = 0; i < productDTOList.size(); i++) {
             ProductDTO productDTO = productDTOList.get(i);
             Integer quantity = quantities.get(i);

             OrderHasProduct orderHasProduct = new OrderHasProduct();
             orderHasProduct.setOrders(orders);
             orderHasProduct.setProduct(productService.getProductById(productDTO.getId()));
             orderHasProduct.setQuantity(quantity);
             orderHasProductRepository.save(orderHasProduct);
             log.info("Product connected to Order. ProductId: {}, OrderId: {}", productDTO.getId(), orders.getId());
         }
     }

    // Cookie management
    private void connectProductToCookie(CartProductDTO cartProductDTO, HttpServletResponse httpServletResponse) {
        Map<Long, Integer> productQuantityMap = new HashMap<>();

        for (int i = 0; i < cartProductDTO.getProducts().size(); i++) {
            ProductDTO productDTO = cartProductDTO.getProducts().get(i);
            Integer quantity = cartProductDTO.getQuantities().get(i);

            Product product = productService.getProductById(productDTO.getId());
            productQuantityMap.put(product.getId(), quantity);
        }

        Cookie cartCookie = new Cookie("cart", "");

        try {
            String base64Value = Base64.getEncoder().encodeToString(new ObjectMapper().writeValueAsBytes(productQuantityMap));
            cartCookie.setValue(base64Value);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        httpServletResponse.addCookie(cartCookie);
        log.info("Cookie added. CookieName: {}, CookieValue: {}", cartCookie.getName(), cartCookie.getValue());
    }

   // public List<CartProductDTO> getShoppingCart(Long clientId) {
   //
   //     List<OrderHasProduct> cartProducts = orderHasProductRepository.findByOrders_Client_IdAndOrders_OrderStatus(clientId, "PENDING");
//
   //     // Mapear a DTO para la respuesta
   //     List<CartProductDTO> cartProductDTOList = new ArrayList<>();
   //     for (OrderHasProduct cartProduct : cartProducts) {
   //         CartProductDTO cartProductDTO = new CartProductDTO();
   //         cartProductDTO.setProducts(cartProduct.getProduct());
   //         cartProductDTO.setQuantities(cartProduct.getQuantity());
   //         cartProductDTOList.add(cartProductDTO);
   //     }
//
   //     return cartProductDTOList;
   // }








}
