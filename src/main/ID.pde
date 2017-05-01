
import java.lang.Comparable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ID implements Comparable<ID> {
    private BigInteger id;
    private final BigInteger MAX_ID  = new BigInteger(1, new byte[]{
          (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF,
          (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF,
          (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF,
          (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF});
          
   private final BigDecimal KEY_SPACE_SIZE = new BigDecimal(MAX_ID);



    /**
     * This is the static init for this class which will create a big decimal of
     * the max value of 160 unsigned bits.
     */

    /**
     * This constructor will take an Ipv4 address in byte form and return an ID
     * in the SHA-1 key space as 160bit integer.
     *
     * @param ip - The byte representation of the ip address.
     */
    ID(byte[] ip) {
      

      
        //does the SHA
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("SHA-1");
            md.reset();
            md.update(ip);
            byte[] hash = md.digest();
            this.id = new BigInteger(1, hash);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    private ID(BigInteger id) {
        this.id = id;
    }

    /**
     * Compares two id to get which is larger.
     *
     * @param other
     * @return
     */
    public int compareTo(ID other) {
        return id.compareTo(other.id);
    }

    /**
     * Allow you to create a new ID from a given offset and retain
     * ciclic funtion from 0 to 2^m. True will add the offset and
     * false will subtract the offset
     */
    public ID createNew(BigInteger offset, boolean toAdd) {
        ID r;
        if(toAdd){
           r = new ID(this.id.add(offset));
           if(r.id.compareTo(MAX_ID) > 0)
              // this means it overflowed
              r = new ID(r.id.subtract(MAX_ID));
        }else{
           r = new ID(this.id.subtract(offset));
           if(r.id.compareTo(BigInteger.valueOf(0)) < 0)
               // this means it went negative
               r = new ID(MAX_ID.add(r.id));
        }
        return r;
        
    }

    /**
     * This function will return this ID's relative postion in the keyspace i.e. a value close to 2^160 for the id
     * portion will return a double close to 1 where as an id close to zero will return 0. We can think of this
     * method as returning how close the ID of this class is to 2^160.
     *
     * @return - Double percentage.
     */
    public double getPercentage() {
        BigDecimal currentKey = new BigDecimal(id);
        BigDecimal percentage = currentKey.divide(KEY_SPACE_SIZE, 30, BigDecimal.ROUND_HALF_DOWN);
        return percentage.doubleValue();
    }

    /**
     * this function checks to see if the current id is in range of the lower and upper bounds.
     * the offset1 and offset2 are booleans used to account for inclussive statements.
     * if the check is exclusive, then the offsets should be set to false
     *
     * @param lower
     * @param upper
     * @param offset1 set to true for inclussive.
     * @param offset2 set to true for inclussive
     * @return
     */
    public boolean inRange(ID lower, ID upper, boolean offset1, boolean offset2){
        BigInteger l = lower.id;
        BigInteger u = upper.id;
        if (offset1)
            l = l.add(BigInteger.valueOf(-1));
        if (offset2)
            u = u.add(BigInteger.valueOf(1));
        if (l.compareTo(u) < 0){
            if (id.compareTo(l) > 0 && id.compareTo(u) < 0)
                return true;
            else
                return false;
        }
        else{
            if (id.compareTo(l) > 0 || id.compareTo(u) < 0)
                return true;
            else
                return false;
        }
    }
    
    @Override
    public String toString(){
      return "" + getPercentage();
    }
}