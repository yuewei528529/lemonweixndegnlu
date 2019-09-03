package com.tmy.repository;




import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.tmy.model.Dengluuser;

@Transactional
public interface DengluuserRepository extends JpaRepository<Dengluuser, String> {
    
	Dengluuser findBycode(String code);

	int findByoAuthNichegn(String oAuthNichegn);
	Dengluuser findByxingming(String xingming);
	Dengluuser findByopenid(String openid);
	void deleteByoAuthNichegn(String getoAuthNichegn);

	boolean existsByoAuthNichegn(String getoAuthNichegn);
	boolean existsByopenid(String openid);
	boolean existsByxingming(String xingming);  
	@Modifying
	@Query(value ="update dengluuser d set d.code = ?1 where d.openid = ?2", nativeQuery = true)
	void setcode(String code, String openid);
	@Modifying
	@Query(value ="update dengluuser d set d.code =null where d.code = ?1", nativeQuery = true)
	void setcode2(String code);
	@Modifying
	@Query(value ="update dengluuser d set d.xingming =?1  where d.openid = ?2", nativeQuery = true)
	void setxingming(String xingming, String openid);
/*	@Query(value = "update Studnet set name=?1 where id=?2 ", nativeQuery = true)  
	@Modifying  
	public void updateOne(String name,int id);*/
}
