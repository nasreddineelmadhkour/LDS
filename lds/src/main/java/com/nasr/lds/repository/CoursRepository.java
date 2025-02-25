package com.nasr.lds.repository;

import com.nasr.lds.entities.Cours;
import com.nasr.lds.entities.Status;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CoursRepository extends JpaRepository<Cours, Long> {

    List<Cours> findByStatus(Status status);
}
