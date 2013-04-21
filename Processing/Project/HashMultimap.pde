import java.util.*;

public class HashMultimap<K, V> {

	private HashMap<K, ArrayList<V>> map = new HashMap<K, ArrayList<V>>();

	public void clear() { map.clear(); }
	public boolean containsKey(Object key) { return map.containsKey(key); }
	public List<V> get(Object key) { return map.get(key); }
	
	public void put(K key, V value) {
		ArrayList<V> list = map.get(key);
		
		if (list == null) {
			list = new ArrayList();
			map.put(key, list);
		}
		
		list.add(value);
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
