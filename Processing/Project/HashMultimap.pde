import java.util.*;

public class HashMultimap<K, V> {

	private int i = 0;
	private HashMap<K, ArrayList<V>> map = new HashMap<K, ArrayList<V>>();

	public boolean containsKey(Object key) { return map.containsKey(key); }
	public List<V> get(Object key) { return map.get(key); }
	public int size() { return i; }
	
	public void put(K key, V value) {
		ArrayList<V> list = map.get(key);
		
		if (list == null) {
			list = new ArrayList();
			map.put(key, list);
		}
		
		list.add(value);

		i++;
	}

	public Collection<V> values() {
		ArrayList<V> list = new ArrayList<V>();
		
		for (List<V> l : map.values()) {
			for (V v : l) {
				list.add(v);
			}
		}

		return list;
	}
}
