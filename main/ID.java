import java.lang.Comparable;

public class ID implements Comparable<ID>{
   final int[] id;
   
   ID(byte[] ip){
      //does the SHA
      id = new int[5];
   }
   
   public int compareTo(ID other){
      return 0;
   }
}