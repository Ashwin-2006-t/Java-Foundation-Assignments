package Assignments.Assignment_4;

import java.util.Arrays;

public class InsertionSort {
    public static void insertionSort(int[] arr) {

        for(int i=1;i<arr.length;i++){
            int temp = arr[i];
            int j = i-1;
            while(j>=0 && arr[j]>temp){
                arr[j+1]= arr[j];
                j--;
            }
            arr[j+1]= temp;
        }
    }
    public static void main(String[] args){

        int [] arr = new int []{42,17,35,8,26};

        System.out.println(Arrays.toString(arr));
        insertionSort(arr);
        System.out.println(Arrays.toString(arr));
        Arrays.sort(arr);
    }

}
