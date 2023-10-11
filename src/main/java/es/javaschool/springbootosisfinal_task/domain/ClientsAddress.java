package es.javaschool.springbootosisfinal_task.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "clients_address")
public class ClientsAddress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "country")
    private String country;

    @Column(name = "city")
    private String city;

    @Column(name = "postalCode")
    private String postalCode;

    @Column(name = "street")
    private String street;

    @Column(name = "home")
    private String home;

    @Column(name = "apartment")
    private String apartment;

    @OneToMany(mappedBy = "clientsAddress", cascade = CascadeType.ALL)
    private List<Order> orders;

    @ManyToOne
    @JoinColumn(name = "client_id")
    private Client client;





}
