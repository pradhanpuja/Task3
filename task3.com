This is the same task but created in different way. In this task i put various oops concept and it is the advanced form of previous code.



import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

interface Account {
    void createAccount(String accountNumber, String pin, double initialBalance);
    void closeAccount(String accountNumber);
    void deposit(String accountNumber, double amount);
    void withdraw(String accountNumber, double amount);
    void transactionHistory(String accountNumber);
    void changePin(String accountNumber, String newPin);
    void balanceCheck(String accountNumber);
    boolean isAccountValid(String accountNumber, String pin);
    void transfer(String fromAccountNumber, String toAccountNumber, double amount);
}
class UserAccount implements Account
{
    String accountNumber;
    String pin;
    private double balance;
    private boolean isClosed;
    private List<Transaction> transactionHistory;
    public UserAccount(String accountNumber, String pin, double initialBalance)
    {
        this.accountNumber = accountNumber;
        this.pin = pin;
        this.balance = initialBalance;
        this.isClosed = false;
        this.transactionHistory = new ArrayList<>();
    }
    public void createAccount(String accountNumber, String pin, double initialBalance)
    {

    }
    public void closeAccount(String accountNumber)
    {
        if (!isClosed)
        {
            isClosed = true;
            System.out.println("Account " +accountNumber+ " is closed.");
        } else
        {
            System.out.println("Account " +accountNumber+ " is already closed.");
        }
    }
    public void deposit(String accountNumber, double amount)
    {
        if (!isClosed)
        {
            this.balance = this.balance+amount;
            transactionHistory.add(new Transaction("Deposit", amount, LocalDate.now()));
            System.out.println("Deposited " +amount+ " into account " +accountNumber);
        } else
        {
            System.out.println("Account is closed. Cannot be deposited.");
        }
    }
    public void withdraw(String accountNumber, double amount)
    {
        if (!isClosed && balance >= amount)
        {
            this.balance = this.balance-amount;
            transactionHistory.add(new Transaction("Withdrawal", amount, LocalDate.now()));
            System.out.println("Withdraw " +amount+ " from account " +accountNumber);
        } else if (isClosed)
        {
            System.out.println("Account is closed. Cannot be withdraw.");
        }
        else
        {
            System.out.println("balance is Insufficient.");
        }
    }
    public void transactionHistory(String accountNumber)
    {
        if (!isClosed)
        {
            System.out.println("Transaction History of " +accountNumber+ "are:");
            for (int i = 0; i < transactionHistory.size(); i++)
            {
                System.out.println(transactionHistory.get(i));
            }
        }
        else
        {
            System.out.println("Account is closed and Cannot have any transaction history.");
        }
    }
    public void changePin(String accountNumber, String newPin)
    {
        if (!isClosed)
        {
            this.pin = newPin;
            System.out.println("PIN changed successfully " +accountNumber);
        } else
        {
            System.out.println("Account is closed. Cannot change PIN.");
        }
    }
    public void balanceCheck(String accountNumber)
    {
        if (!isClosed)
        {
            System.out.println("Balance of " +accountNumber+ " is: " +this.balance);
        }
        else
        {
            System.out.println("Account is closed. Cannot check balance.");
        }
    }
    public boolean isAccountValid(String accountNumber, String pin)
    {
        return this.accountNumber.equals(accountNumber) && this.pin.equals(pin) && !isClosed;
    }
    public void transfer(String fromAccountNumber, String toAccountNumber, double amount)
    {
        if (!isClosed && balance >= amount)
        {
            for (int i = 0; i < ATM.accountList.size(); i++)
            {
                UserAccount account = ATM.accountList.get(i);
                if (account.accountNumber.equals(toAccountNumber) && !account.isClosed)
                {
                    this.balance = balance-amount;
                    account.balance = balance+amount;
                    transactionHistory.add(new Transaction("Transfer to " +toAccountNumber, amount, LocalDate.now()));
                    account.transactionHistory.add(new Transaction("Transfer from " +fromAccountNumber, amount, LocalDate.now()));
                    System.out.println("Transferred" +amount+ "from" +fromAccountNumber+ "to" +toAccountNumber);
                    return;
                }
            }
            System.out.println(" account is closed or not found any account number for transfer the amount.");
        }
        else if (isClosed)
        {
            System.out.println("Account is closed. Cannot transfer money.");
        }
        else
        {
            System.out.println("Insufficient balance.");
        }
    }
}
class Transaction
{
    private String type;
    private double amount;
    private LocalDate date;
    public Transaction(String type, double amount, LocalDate date)
    {
        this.type = type;
        this.amount = amount;
        this.date = date;
    }
    public String toString()
    {
        return type+ " of " +amount+ " on " +date.toString();
    }
}
public class ATM
{
    static List<UserAccount> accountList = new ArrayList<>();
    public static void main(String[] args)
    {
        accountList.add(new UserAccount("78476134638", "1234", 1000.0));
        accountList.add(new UserAccount("97248757879", "5678", 500.0));
        accountList.add(new UserAccount("75475357370", "3546", 10000.0));
        accountList.add(new UserAccount("67845876598", "8675", 2000.0));
        accountList.add(new UserAccount("99845987589", "9898", 8000.0));
        accountList.add(new UserAccount("62983949867", "6523", 30000.0));
        Scanner sc = new Scanner(System.in);
        int attempts = 0;
        UserAccount currentAccount = null;
        while (attempts < 3)
        {
            System.out.print("Enter your account number: ");
            String accountNumber = sc.nextLine();
            System.out.print("Enter your 4-digit PIN: ");
            String pin = sc.nextLine();
            currentAccount = validateAccount(accountNumber, pin);
            if (currentAccount != null)
            {
                System.out.println("Validation successful.");
                options(sc, currentAccount);
                break;
            } else
            {
                System.out.println("Validation failed. Please check your account number or PIN.");
                attempts++;
                if (attempts == 3)
                {
                    System.out.println("Too many attempts. Your account is locked.");
                }
            }
        }
        sc.close();
    }
    private static UserAccount validateAccount(String accountNumber, String pin)
    {
        for (UserAccount account : accountList)
        {
            if (account.isAccountValid(accountNumber, pin))
            {
                return account;
            }
        }
        return null;
    }
    private static void options(Scanner sc, UserAccount currentAccount)
    {
        int choice;
        do {
            System.out.println("1. Create Account");
            System.out.println("2. Close Account");
            System.out.println("3. Deposit");
            System.out.println("4. Withdraw");
            System.out.println("5. Transaction History");
            System.out.println("6. Change PIN");
            System.out.println("7. Check Balance");
            System.out.println("8. Transfer");
            System.out.println("9. Quit");
            System.out.print("Choose an option: ");
            choice = sc.nextInt();
            switch (choice)
            {
                case 1:
                    createNewAccount(sc);
                    break;
                case 2:
                    closeAccount(sc, currentAccount);
                    break;
                case 3:
                    deposit(sc, currentAccount);
                    break;
                case 4:
                    withdraw(sc, currentAccount);
                    break;
                case 5:
                    currentAccount.transactionHistory(currentAccount.accountNumber);
                    break;
                case 6:
                    changePin(sc, currentAccount);
                    break;
                case 7:
                    currentAccount.balanceCheck(currentAccount.accountNumber);
                    break;
                case 8:
                    transfer(sc, currentAccount);
                    break;
                case 9:
                    System.out.println("Quit.");
                    break;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        } while (choice != 9);
    }
    private static void createNewAccount(Scanner sc)
    {
        System.out.print("Enter a new account number: ");
        String accountNumber = sc.next();
        System.out.print("Enter a new PIN: ");
        String pin = sc.next();
        System.out.print("Enter your first deposit amount: ");
        double initialDeposit = sc.nextDouble();
        UserAccount newAccount = new UserAccount(accountNumber, pin, initialDeposit);
        accountList.add(newAccount);
        System.out.println("Account created successfully.");
    }
    private static void closeAccount(Scanner sc, UserAccount currentAccount)
    {
        System.out.print("Do you want to close the account? (yes/no): ");
        String response = sc.next();
        if ("yes".equals(response.toLowerCase()))
        {
            currentAccount.closeAccount(currentAccount.toString());
        }
    }
    private static void deposit(Scanner sc, UserAccount currentAccount)
    {
        System.out.print("Enter the amount to deposit: ");
        double amount = sc.nextDouble();
        currentAccount.deposit(currentAccount.accountNumber, amount);
    }
    private static void withdraw(Scanner sc, UserAccount currentAccount)
    {
        System.out.print("Enter the amount to withdraw: ");
        double amount = sc.nextDouble();
        currentAccount.withdraw(currentAccount.accountNumber, amount);
    }
    private static void changePin(Scanner sc, UserAccount currentAccount)
    {
        System.out.print("Enter a new PIN: ");
        String newPin = sc.next();
        currentAccount.changePin(currentAccount.accountNumber, newPin);
    }
    private static void transfer(Scanner sc, UserAccount currentAccount)
    {
        System.out.print("Enter the account number to transfer money : ");
        String toAccountNumber = sc.next();
        System.out.print("Enter the amount to transfer: ");
        double amount = sc.nextDouble();
        currentAccount.transfer(currentAccount.accountNumber, toAccountNumber, amount);
    }
}

