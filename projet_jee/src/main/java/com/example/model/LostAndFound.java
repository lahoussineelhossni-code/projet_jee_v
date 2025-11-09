package com.example.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "lost_and_found")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class LostAndFound {

    public Student getOwner() {
        return owner;
    }

    public void setOwner(Student owner) {
        this.owner = owner;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String description;
    private String location; // lieu de l’objet trouvé

    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student owner;
}
