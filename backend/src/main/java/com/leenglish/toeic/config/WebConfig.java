package com.leenglish.toeic.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
        @Override
        public void addResourceHandlers(@NonNull ResourceHandlerRegistry registry) {
                // Serve audio files
                registry.addResourceHandler("/audio/**")
                                .addResourceLocations("classpath:/static/audio/");

                // Serve image files from external images directory
                registry.addResourceHandler("/images/**")
                                .addResourceLocations("file:images/")
                                .setCachePeriod(3600);

                // Serve other static resources
                registry.addResourceHandler("/static/**")
                                .addResourceLocations("classpath:/static/");

                // Add cache control for audio files
                registry.addResourceHandler("/audio/**")
                                .addResourceLocations("classpath:/static/audio/")
                                .setCachePeriod(3600);

                // ✅ MEDIA FILES - Map /files/** to serve both images and audio
                registry.addResourceHandler("/files/images/lessons/**")
                                .addResourceLocations("classpath:/lessons/")
                                .setCachePeriod(3600);

                registry.addResourceHandler("/files/audio/**")
                                .addResourceLocations("classpath:/")
                                .setCachePeriod(3600);
        }
}
