package org.springframework.samples.petclinic.messaging;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.samples.petclinic.messaging.Email;

public interface EmailRepository extends MongoRepository<Email, String> {}