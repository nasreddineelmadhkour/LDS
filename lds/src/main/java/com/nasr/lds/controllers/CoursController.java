package com.nasr.lds.controllers;

import com.nasr.lds.entities.Cours;
import com.nasr.lds.services.IServiceCours;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cours")
public class CoursController {
    @Autowired
    private IServiceCours serviceCours;

    @GetMapping("/all")
    public List<Cours> getCours(){
        return serviceCours.getCours();
    }
    @GetMapping("/get_cours_completed")
    public List<Cours> getCoursCompleted(){
        return serviceCours.getCoursCompleted();
    }

    @GetMapping("/get_cours_in_progress")
    public List<Cours> getCoursInProgress(){
        return serviceCours.getCoursInProgress();
    }

    @PostMapping("/add")
    public Cours addCours(@RequestBody Cours cours){
        return serviceCours.addCours(cours);
    }
    @PostMapping("/saved/{id}")
    public Boolean savedCours(@PathVariable Long id){
        return serviceCours.savedCours(id);
    }

    @GetMapping("/getSubtitleLast20Words")
    public String getSubtitleLast20Words(){

        return serviceCours.getSubtitleLast20Words(Long.valueOf(4));
    }


}
