package main;

import java.lang.Comparable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ID implements Comparable<ID> {
    private BigInteger id;
    private static final BigDecimal KEY_SPACE_SIZE;


    /**
     * This is the static init for this class which will create a big decimal of
     * the max value of 160 unsigned bits.
     */
    static {
        KEY_SPACE_SIZE = new BigDecimal(new BigInteger(1, new byte[]{
                (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF,
                (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF,
                (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF,
                (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF, (byte) 0xFF}));
    }

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

    public ID createNew(BigInteger offset) {
        return new ID(this.id.subtract(offset));
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
     * the offset1 and offset2 are int used to account for inclussive statements.
     * if the check is exclusive, then the offsets should be set to 0
     * @param lower
     * @param upper
     * @param offset1
     * @param offset2
     * @return
     */
    public boolean inRange(ID lower, ID upper, int offset1, int offset2){
        BigInteger l = lower.id;
        BigInteger u = upper.id;
        l = l.add(BigInteger.valueOf(offset1));
        u = u.add(BigInteger.valueOf(offset2));
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
}