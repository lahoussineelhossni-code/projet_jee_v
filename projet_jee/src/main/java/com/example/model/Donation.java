package com.example.model;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "donations")
@Setter @Getter
@NoArgsConstructor @AllArgsConstructor
public class Donation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String description;

    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student owner;
}
