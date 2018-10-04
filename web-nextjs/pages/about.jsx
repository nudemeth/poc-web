import React from 'react'
import PropTypes from 'prop-types'
import Container from '../components/layout/Container'
import { initGreeting, updateGreeting } from '../actions/about.actions'
import { withReduxSaga } from '../store/store'

class About extends React.Component {
    constructor(props) {
        super(props)
    }

    static async getInitialProps({ store }) {
        store.dispatch(initGreeting('This is from server'))
        return {}
    }

    static propTypes = {
        dispatch: PropTypes.func.isRequired,
        greeting: PropTypes.string.isRequired
    }

    componentDidMount() {
        this.props.dispatch(updateGreeting())
    }

    render() {
        return (
            <Container title='About'>
                <h1>This is About Page: {this.props.greeting}</h1>
            </Container>
        )
    }
}

const mapStateToProps = ({ aboutReducer: { greeting }}) => ({ greeting })

export default withReduxSaga(mapStateToProps)(About)
export { About }