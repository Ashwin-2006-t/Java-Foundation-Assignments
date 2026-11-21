package AlgoDemo;

import java.util.ArrayDeque;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

public class StackDemo {
    public static void main(String[] args) {

        Queue<String> queue = new ArrayDeque<>();
        queue.offer("abc");
        queue.poll();

        Queue<String> linkedList = new LinkedList<>();
        linkedList.offer("abc");
        linkedList.poll();


        ArrayDeque<String> newStack = new ArrayDeque<>();
        newStack.push("Harry potter");
        newStack.push("Ronald Weasley");
        newStack.push("hermione Granger");

        System.out.println("Stack: " + newStack);

        System.out.println("Peek is: " + newStack.peek());
        System.out.println("Pop is " + newStack.pop());
        System.out.println("Peek is: " + newStack.peek());
        System.out.println("size is: " + newStack.size());


        Stack<String> oldStack = new Stack<>();
        oldStack.push("frodo baggins");
        oldStack.push("samwell gamajee");
        System.out.println(oldStack);
    }
}