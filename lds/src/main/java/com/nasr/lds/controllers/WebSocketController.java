package com.nasr.lds.controllers;

import com.nasr.lds.Dto.CoursDto;
import com.nasr.lds.entities.Cours;
import com.nasr.lds.services.IServiceCours;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller   @Slf4j @AllArgsConstructor
public class WebSocketController {

    @Autowired
    private IServiceCours serviceCours;

    @MessageMapping("/get_from_room/{roomId}")
    @SendTo("/send_to_room/{roomId}")
    public CoursDto trackingOrders(@DestinationVariable String roomId,CoursDto coursDto) {

        System.out.println("ID Order : "+coursDto.getId()+"| name:" +coursDto.getName()+" | description:"+coursDto.getDescription());
        serviceCours.updateCours(coursDto.getId() , coursDto.getDescription());
        coursDto.setDescription(serviceCours.getSubtitleLast20Words(coursDto.getId()));
        return  coursDto;

    }

}