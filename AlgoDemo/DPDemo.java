package AlgoDemo;

public class DPDemo {

    public static void main(String[] args) {

        int[] transactions = {5000 , -1200, 300, -400, -350, 500, -460, -700, 900};
        int[] balance = new int[transactions.length + 1];
        balance[0] = 0;

        for( int i=1;i<=transactions.length ; i++){
            balance[i] = balance[i-1] + transactions[i-1] ;
        }

        System.out.println("Day 3 to Day 8 " + (balance[8] - balance[3]));
    }
}
