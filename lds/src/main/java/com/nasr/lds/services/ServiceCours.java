package com.nasr.lds.services;

import com.nasr.lds.entities.Cours;
import com.nasr.lds.entities.Status;
import com.nasr.lds.repository.CoursRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ServiceCours implements IServiceCours {
    @Autowired
    CoursRepository coursRepository;


    @Override
    public List<Cours> getCours() {
        return coursRepository.findAll();
    }


    public void updateCours(Long id, String newDescription) {
        Cours cours = coursRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cours not found"));

        String oldDescription = cours.getDescription();
        String last5Words = getLast5Words(oldDescription);

        Set<String> last5WordSet = new HashSet<>(Arrays.asList(last5Words.split("\\s+")));
        List<String> newWords = Arrays.asList(newDescription.split("\\s+"));

        List<String> filteredNewWords = newWords.stream()
                .filter(word -> !last5WordSet.contains(word))
                .collect(Collectors.toList());

        String updatedDescription = oldDescription + " " + String.join(" ", filteredNewWords);

        cours.setDescription(updatedDescription.trim());
        coursRepository.save(cours);

        System.out.println("Updated description: " + updatedDescription);
    }

    @Override
    public Cours addCours(Cours cours) {
        Cours courss = new Cours();
        courss.setName(cours.getName());
        courss.setDescription("");
        courss.setDate(new Date());
        courss.setNameprofessor(cours.getNameprofessor());
        courss.setStatus(Status.IN_PROGRESS);
        return coursRepository.save(courss);


    }

    @Override
    public List<Cours> getCoursCompleted() {
        return coursRepository.findByStatus(Status.COMPLETED);
    }

    @Override
    public List<Cours> getCoursInProgress() {
        return coursRepository.findByStatus(Status.IN_PROGRESS);
    }

    @Override
    public Cours getOneCour(Long id) {
        return coursRepository.findById(id).orElse(null);
    }

    @Override
    public String getSubtitleLast20Words(Long id) {

        Cours cours = coursRepository.findById(id).orElse(null);

        if (cours!= null){
            return getLast5Words(cours.getDescription());
        }

        return "";
    }

    @Override
    public Boolean savedCours(Long id) {
        Cours cours = coursRepository.findById(id).orElse(null);
        if(cours != null){
            cours.setStatus(Status.COMPLETED);
            coursRepository.save(cours);
            return true;
        }
        else {
            return false;
        }

    }


    public String getLast5Words(String description) {
        if (description == null || description.isEmpty()) {
            return "";
        }

        String[] words = description.split("\\s+"); // Split by spaces
        int wordCount = words.length;

        if (wordCount <= 5) {
            return description; // Return full description if <= 20 words
        }

        return String.join(" ", java.util.Arrays.copyOfRange(words, wordCount - 5, wordCount));
    }

    public String getLast3Words(String description) {
        if (description == null || description.isEmpty()) {
            return "";
        }

        String[] words = description.split("\\s+"); // Split by spaces
        int wordCount = words.length;

        if (wordCount <= 3) {
            System.out.println(description);
            return description; // Return full description if <= 4 words
        }

        return String.join(" ", java.util.Arrays.copyOfRange(words, wordCount - 3, wordCount));
    }

}
