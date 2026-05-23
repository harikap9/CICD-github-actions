package com.example.cicd;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

public class NormalJarApplication {

    public static void main(String[] args) throws IOException {
        int port = portFrom(args);
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        server.createContext("/", exchange -> writeJson(exchange, 200,
                "{\"status\":\"ok\",\"message\":\"Normal Java JAR is running\"}"));
        server.createContext("/health", exchange -> writeJson(exchange, 200,
                "{\"status\":\"UP\"}"));

        server.start();
        System.out.println("Normal Java JAR started on http://localhost:" + port);
    }

    static int portFrom(String[] args) {
        if (args.length == 0 || args[0] == null || args[0].isBlank()) {
            return 8080;
        }
        return Integer.parseInt(args[0]);
    }

    private static void writeJson(HttpExchange exchange, int status, String body) throws IOException {
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().add("Content-Type", "application/json");
        exchange.sendResponseHeaders(status, bytes.length);
        try (OutputStream outputStream = exchange.getResponseBody()) {
            outputStream.write(bytes);
        }
    }
}
