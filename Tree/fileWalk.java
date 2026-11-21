package Tree;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class fileWalk {

    public static void main(String[] args) throws IOException {

        Path path = Path.of("D:\\ASHWIN\\Ashwin Collage\\Hexaware\\Hexaware_Java_Foundation\\src");

        Files.walk(path)
                .forEach(System.out::println);
    }
}