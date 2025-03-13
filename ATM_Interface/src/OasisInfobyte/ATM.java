package OasisInfobyte;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class ATM
{
    private static final String User_id = "Pradhan82";
    private static final String Pin = "2035";
    private static double balance = 10000.00;
    private static List<Transaction> transactionHistory = new ArrayList<>();
    private static List<Transaction> AccountList = new ArrayList<>();

    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);
        int attempts = 0;

        while (attempts < 3)
        {
            System.out.print("Enter your username: ");
            String UI = sc.nextLine();
            System.out.print("Enter your 4-digit PIN: ");
            String PIN = sc.nextLine();

            if (isValidation(UI, PIN))
            {
                System.out.println("Validation  successful.");
                options(sc);
                break;
            } else
            {
                System.out.println("Validation failed. Please check your username or PIN.");
                attempts++;
                if (attempts == 3)
                {
                    System.out.println("Too many attempts. Your account is locked.");
                }
            }
        }

       sc.close();
    }

    private static boolean isValidation(String username, String pin)
    {
        return username.equals(User_id) && pin.equals(Pin);
    }
    private static void options(Scanner sc)
    {
        int choice;
        do {
            System.out.println("Various operations are: ");
            System.out.println("1. Transaction History ");
            System.out.println("2. Withdraw ");
            System.out.println("3. Deposit ");
            System.out.println("4. Transfer ");
            System.out.println("5. Quit ");
            System.out.println("Choose any options to perform that task: ");
            choice = sc.nextInt();
            switch (choice)
            {
                case 1:
                    Transaction_History();
                    break;
                case 2:
                    withdraw(sc);
                    break;
                case 3:
                    deposit(sc);
                    break;
                case 4:
                    Transfer(sc);
                    break;
                case 5:
                    System.out.println("Quit...");
                    System.exit(0);
                    break;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }while(choice != 4);
    }

    private static void Transaction_History()
    {
        if(transactionHistory.isEmpty())
        {
            System.out.println("Transactions history are not available.");
        }
        else
        {
            System.out.println("Transactions history are: ");
            for(int i=0;i<transactionHistory.size();i++)
            {
                System.out.println(transactionHistory.get(i));
            }
        }
    }
    private static void withdraw(Scanner sc)
    {
        System.out.print("Enter the amount to withdraw: ");
        double amount = sc.nextDouble();
        if (amount <= balance)
        {
            balance = balance-amount;
            Transaction transact = new Transaction("Withdrawal", amount, LocalDate.now());
            transactionHistory.add(transact);
            System.out.println("Successfully withdrew " + amount + "from your account.");
        } else
        {
            System.out.println("Insufficient balance.");
        }
    }
    private static void deposit(Scanner sc)
    {
        System.out.println("Enter the amount to deposit: ");
        double amount =  sc.nextDouble();
        balance = balance+amount;
        Transaction transact = new Transaction("deposit", amount, LocalDate.now());
        transactionHistory.add(transact);
        System.out.println("Successfully deposited " + amount + "in your account.");
    }
    private static void Transfer(Scanner sc)
    {
        System.out.print("Enter the account number to transfer to: ");
        sc.nextLine();
        String accountNumber = sc.nextLine();
        System.out.print("Enter the amount to transfer: ");
        double amount = sc.nextDouble();

        if (amount <= balance)
        {
            balance = balance - amount;
            Transaction transact = new Transaction("Transfer to " + accountNumber, amount, LocalDate.now());
            transactionHistory.add(transact);
            System.out.println("Successfully transferred " + amount + " to account: " + accountNumber);
        }
        else
        {
            System.out.println("Insufficient balance to transfer.");
        }
    }
}

class Transaction {
    private String type;
    private double amount;
    private LocalDate date;
    public Transaction(String type, double amount, LocalDate date) {
        this.type = type;
        this.amount = amount;
        this.date = date;
    }
    public String toString() {
        return type + " of " + amount + " on " + date.toString();
    }
}






