import java.lang.Comparable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ID implements Comparable<ID>{
    private BigInteger id;
    private BigDecimal keySpaceSize = new BigDecimal(new BigInteger(1,new byte[]{
            (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF,
            (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF,
            (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF,
            (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF, (byte)0xFF}));

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
    
    private ID(BigInteger id){
      this.id = id;
    }

    public int compareTo(ID other){
      return id.compareTo(other.id);
    }
    
    public ID createNew(BigInteger offset){
      return new ID(this.id.subtract(offset));
    }

    public double getPercentage(){
        BigDecimal currentKey = new BigDecimal(id);
        BigDecimal percentage = currentKey.divide(keySpaceSize,30, BigDecimal.ROUND_HALF_DOWN);
        return percentage.doubleValue();
    }
}