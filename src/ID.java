import java.lang.Comparable;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ID implements Comparable<ID>{
    private BigInteger id;

    ID(byte[] ip){
        //does the SHA
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("SHA-1");
            md.reset();
            md.update(ip);
            byte[] hash = md.digest();
            this.id = new BigInteger(1, hash);

        }catch(NoSuchAlgorithmException e){
            e.printStackTrace();
        }

    }

    public int compareTo(ID other){
      return id.compareTo(other.id);
    }

}