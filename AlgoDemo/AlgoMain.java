package AlgoDemo;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class AlgoMain {

    public static void main(String[] args) {

        List<Integer> list = Arrays.asList(4,2,7,9,1,3,5,8);

        int num = 5;

        System.out.println("Sample size, number of Ids " + list.size());
        System.out.println("---------------------BRUTE FORCE---------------------------");
        bruteForce(list,num);
        bruteForce(list,10);

        System.out.println("---------------------DIVIDE AND CONQUER---------------------");
        divideAndConquer(list,num);
        divideAndConquer(list,7);

        System.out.println("---------------------DIVIDE AND CONQUER EASY---------------------");
        divideAndConquerEasy(list,num);
        divideAndConquerEasy(list,7);
    }

    private static void divideAndConquerEasy(List<Integer> list, int num) {
        Collections.sort(list);
        int index = Arrays.binarySearch(list.toArray(),num);
        if(index < 0){
            System.out.println("Number Not Found: " + num);
        }
        else{
            System.out.println("Number Found at index : " + index);
        }
    }

    private static void divideAndConquer(List<Integer> list, int num) {
        int iterations = 0;

        Collections.sort(list);

        int low = 0;
        int high = list.size() - 1;

        while(low <= high) {
            iterations++;
            int mid = (low + high) / 2;
            if (num == list.get(mid)) {
                System.out.println("Number found " + num);
                System.out.println("It took " + iterations + " Iterations");
                return;
            }

            if(list.get(mid) < num){
                low = mid + 1;
            }
            else{
                high = mid - 1;
            }
        }
        System.out.println("Number Not Found: " + num);
        System.out.println("It took " + iterations + " Iterations");
    }

    private static void bruteForce(List<Integer> list, int num) {
        int iterations = 0;
        for(int e : list){
            iterations++;
            if(num == e){
                System.out.println("Number Found: " + num);
                System.out.println("It took " + iterations + " Iterations");
                return;
            }
        }
        System.out.println("Number Not Found: " + num);
        System.out.println("It took " + iterations + " Iterations");

    }


}