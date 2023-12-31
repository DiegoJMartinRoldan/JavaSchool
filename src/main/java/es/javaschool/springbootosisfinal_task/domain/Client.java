package es.javaschool.springbootosisfinal_task.domain;

import com.fasterxml.jackson.annotation.*;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "client")
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "surname")
    private String surname;

    @Column(name = "date_of_birth")
    @Temporal(TemporalType.DATE)
    private Date dateOfBirth;

    @Column(name = "email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "role")
    private String role;


    @JsonManagedReference
   @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
   private List<Orders> orders;

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private List<ClientsAddress> clientsAddresses;



}
