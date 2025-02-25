package com.nasr.lds.services;

import com.nasr.lds.entities.Cours;

import java.util.List;

public interface IServiceCours {

    List<Cours> getCours();
    void updateCours(Long id, String description);
    Cours addCours(Cours cours);

    List<Cours> getCoursCompleted();

    List<Cours> getCoursInProgress();

    String getSubtitleLast20Words(Long id);

    Boolean savedCours(Long id);
}
