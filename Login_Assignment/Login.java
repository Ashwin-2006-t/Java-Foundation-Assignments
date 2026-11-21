package Login_Assignment;

import java.util.Scanner;

public class Login {
    public static void main(String[] args) {

        Scanner sc=new Scanner(System.in);

        System.out.println("Enter the username:");
        String userName=sc.next();

        System.out.println("Enter the password:");
        String password=sc.next();

        LoginService loginService=new LoginService();

        if(loginService.isValidate(userName, password)) {
            System.out.println("Welcome " + userName+" \n You can enter into System");
        }
        else {
            System.out.println("Invalid credentials \n Cant enter into System" +
                    "\nPlease try again");
        }
    }

}
