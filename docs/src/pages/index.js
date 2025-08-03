import { useHistory } from '@docusaurus/router';
import { useEffect } from 'react';

export default function Home() {
  const history = useHistory();

  useEffect(() => {
    history.replace('/docs/quickstart');
  }, [history]);

  return (
    <div style={{ padding: '2rem', textAlign: 'center' }}>
      <p>Redirecting to quickstart...</p>
    </div>
  );
}