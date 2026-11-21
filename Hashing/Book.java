package Hashing;

public class Book {
    int id;
    String Name;
    String address;

    public Book(int id,String name) {
        Name = name;
        this.id = id;
    }

    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", Name='" + Name + '\'' +
                ", address='" + address + '\'' +
                '}';
    }
}
