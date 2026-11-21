package Assignments.Assignment_4;

import java.util.Arrays;

public class BubbleSort {

    public static void main(String[] args) {

        int[] arr = {42, 17, 35, 8, 36};
        int n = arr.length;
        boolean swap = true;

        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                    swap = false;
                }
            }
            if (swap){
                break;
            }
        }
        System.out.println(Arrays.toString(arr));
    }
}
