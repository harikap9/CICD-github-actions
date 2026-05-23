package com.example.cicd;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class NormalJarApplicationTest {

    @Test
    void defaultsToPort8080() {
        assertEquals(8080, NormalJarApplication.portFrom(new String[]{}));
    }

    @Test
    void acceptsPortFromFirstArgument() {
        assertEquals(9090, NormalJarApplication.portFrom(new String[]{"9090"}));
    }
}
