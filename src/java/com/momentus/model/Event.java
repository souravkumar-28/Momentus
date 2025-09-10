package com.momentus.model;

import java.util.Date;

public class Event {
    private int id;
    private String title;
    private String description;
    private double amount;
    private Date eventDate;
    private String location;
    private String status;

    // Constructor (empty)
    public Event() {}

    // Constructor (all fields)
    public Event(int id, String title, String description, double amount, Date eventDate, String location, String status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.amount = amount;
        this.eventDate = eventDate;
        this.location = location;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
