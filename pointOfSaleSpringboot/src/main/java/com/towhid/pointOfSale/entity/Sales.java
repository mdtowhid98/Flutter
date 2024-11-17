package com.towhid.pointOfSale.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor

public class Sales {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String customername;
    private Date salesdate;
    private int totalprice;

    private int quantity;
    @Column(nullable = true)
    private float discount=0.00f;



    @ManyToMany
//    private List<Product> product;
    private List<Product> product = new ArrayList<>();


    @ManyToOne
    private SalesDetails salesDetails;

}

