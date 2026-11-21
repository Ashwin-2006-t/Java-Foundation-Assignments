package lms;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class SortApp {

    static String direction;
    public static void main(String[] args) {

//        Course c1 = new Course(1,"Java Programming", 1200);
//        Course c2 = new Course(2, "SQL Programming", 800);
//        Course c3 = new Course(3,"React Programming", 2100);
//        Course c4 = new Course(4,  "Data Structure", 1100);

        Course c1 = new Course(101, "Java", 15000);
        Course c2 = new Course(102, "Python", 12000);
        Course c3 = new Course(103, "React", 15000);
        Course c4 = new Course(104, "SQL", 8000);
        Course c5 = new Course(105, "Angular", 12000);

        List<Course> courses = new ArrayList<>();
        courses.add(c1);
        courses.add(c2);
        courses.add(c3);
        courses.add(c4);
        courses.add(c5);
        courses.forEach(System.out::println);

        sortCourseASC(courses);

        System.out.println("Ascending Order by Fees:");
//        for (Course c : courses) {
//            System.out.println(c);
//        }
        courses.forEach(System.out::println);

        sortCourseDESC(courses);
        System.out.println("\nDescending Order Fees:");
        courses.forEach(System.out::println);


        sortCoursesName(courses);
        System.out.println("\nDescending Order Fees:");
        courses.forEach(System.out::println);
    }

    // Sort by fee in ascending order
    public static void sortCourseASC(List<Course> courses) {
        direction = "ASC";
        Collections.sort(courses, new CourseUtility(direction));
    }
    public static void sortCourseDESC(List<Course> courses) {
        direction = "DESC";
        Collections.sort(courses, new CourseUtility(direction));
    }
    public static void sortCoursesName(List<Course> courses) {
        direction = "Name";
        Collections.sort(courses, new CourseUtility(direction));
    }
}
