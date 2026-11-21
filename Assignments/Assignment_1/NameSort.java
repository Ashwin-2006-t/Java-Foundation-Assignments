package Assignments.Assignment_1;

import java.util.Comparator;

public class NameSort implements Comparator<Course>{

    @Override
    public int compare(Course o1, Course o2) {

        return o1.name.compareTo(o2.name);
    }

}
